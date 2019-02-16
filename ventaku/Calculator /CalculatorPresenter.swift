//
//  CalculatorPresenter.swift
//  ventaku
//
//  Created by 宮倉宗平 on 2019/02/13.
//  Copyright © 2019 Sohei Miyakura. All rights reserved.
//

import Foundation

protocol CalculatorPresenterInput {
    func tapNumberButton(numberText: String?)
    func tapDecimalButton(desimalText: String?)
    func tapClearButton()
    func tapBackButton()
    func tapCalculationButton(calculationCount: Int)
    func tapResultButton()
    func tapStartRoundBrackets(startRoundBrackets: String?)
    func tapEndRoundBrackets(endRoundBrackets: String?)
}

protocol CalculatorPresenterOutput: AnyObject {
    func updateCalculationResult(resultText: String)
    func updateFormula(formulaText: String)
}

final class CalculatorPresenter: CalculatorPresenterInput {
    
    private(set) var currentResultNumber: Double = 0
    private(set) var currentFormulaText: String = ""
    
    private(set) var numberOfResultNumberDesimal: Double = 0
    
    private(set) var isInputtedDecimal: Bool = false
    private(set) var isStartedInputNumber: Bool = false
    private(set) var isResulted: Bool = false
    
    private weak var view: CalculatorPresenterOutput!
    
    init(view: CalculatorPresenterOutput) {
        self.view = view
    }
    
    func tapNumberButton(numberText: String?) {
        guard var resultText = numberText else { return }
        
        if isResulted { return }
        if isInputtedDecimal {
            numberOfResultNumberDesimal += 1
            currentResultNumber = currentResultNumber + Double(resultText)! * pow(0.1, numberOfResultNumberDesimal)
        } else {
            currentResultNumber = currentResultNumber * 10 + Double(resultText)!
        }
        
        isStartedInputNumber = true

        currentFormulaText += String(resultText)
        resultText = String(currentResultNumber)
        resultText = modifiedResultTextFromDouble(resultText: resultText)
        
        self.view.updateCalculationResult(resultText: resultText)
        self.view.updateFormula(formulaText: currentFormulaText)
    }
    
    func tapClearButton() {
        currentResultNumber = 0
        currentFormulaText = ""
        
        numberOfResultNumberDesimal = 0
        isInputtedDecimal = false
        isStartedInputNumber = false
        isResulted = false
        var resultText = String(currentResultNumber)
        
        resultText = modifiedResultTextFromDouble(resultText: resultText)
        
        self.view.updateCalculationResult(resultText: resultText)
        self.view.updateFormula(formulaText: currentFormulaText)
    }
    
    func tapBackButton() {
        currentResultNumber = currentResultNumber / 10
        let resultText = String(currentResultNumber)
        currentFormulaText = String(currentResultNumber)
        
        self.view.updateCalculationResult(resultText: resultText)
        self.view.updateFormula(formulaText: currentFormulaText)
    }
    
    func tapDecimalButton(desimalText: String?) {
        guard let resultText = desimalText else { return }
        
        if isInputtedDecimal { return }
        if isResulted { return }
        if !isStartedInputNumber { return }
        
        currentFormulaText += String(resultText)
        isInputtedDecimal = true
        
        self.view.updateFormula(formulaText: currentFormulaText)
    }
    
    func tapCalculationButton(calculationCount: Int) {
//        if !isStartedInputNumber { return }
        if currentResultNumber == 0 { return }
        
        let calculationSymbolText = ["=", "+", "-", "*", "/"]
        var resultText = calculationSymbolText[calculationCount]
        currentResultNumber = 0
        currentFormulaText += " \(resultText) "
        
        numberOfResultNumberDesimal = 0
        isInputtedDecimal = false
        isStartedInputNumber = false
        isResulted = false
        
        resultText = String(currentResultNumber)
        resultText = modifiedResultTextFromDouble(resultText: resultText)
        
        self.view.updateCalculationResult(resultText: resultText)
        self.view.updateFormula(formulaText: currentFormulaText)
    }
    
    func tapResultButton() {
        if !isStartedInputNumber { return }
        
        let expression = NSExpression(format: currentFormulaText)
        let result = expression.expressionValue(with: nil, context: nil) as! Double
        
        numberOfResultNumberDesimal = 0
        isInputtedDecimal = false
        isStartedInputNumber = false
        
        let resultText = String(result)
        currentFormulaText = " \(resultText)"
        
        isResulted = true
        
        self.view.updateCalculationResult(resultText: resultText)
        self.view.updateFormula(formulaText: currentFormulaText)
    }
    
    func tapStartRoundBrackets(startRoundBrackets: String?) {
        print("start")
        guard let resultText = startRoundBrackets else { return }
        
        currentFormulaText += " \(resultText) "
        
        self.view.updateFormula(formulaText: currentFormulaText)
    }
    
    func tapEndRoundBrackets(endRoundBrackets: String?) {
        print("end")
        guard let resultText = endRoundBrackets else { return }
        
        currentFormulaText += " \(resultText) "
        
        self.view.updateFormula(formulaText: currentFormulaText)
    }
}

extension CalculatorPresenter {
    
    private func modifiedResultTextFromDouble(resultText: String) -> String {
        var modifiedResultText = resultText
        
        let isDoubled = resultText.hasSuffix(".0")
        if isDoubled && numberOfResultNumberDesimal < 1{
            modifiedResultText = String(format: "%0.0f", currentResultNumber)
        }
        
        return modifiedResultText
    }
    
    private func convertToFormulaFromText(formulaText: String) throws -> Double {
        let expression = NSExpression(format: currentFormulaText)
        let result = expression.expressionValue(with: nil, context: nil) as! Double
        return result
    }
    
    
    private func resetAllFields() {
        resetResultFields()
        resetDecimalFields()
    }
    
    private func resetResultFields() {
        currentResultNumber = 0
        currentFormulaText = ""
        isStartedInputNumber = false
    }
    
    private func resetDecimalFields() {
        numberOfResultNumberDesimal = 0
        isInputtedDecimal = false
        isStartedInputNumber = false
    }
}
