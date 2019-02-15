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
    func tapCalculationButton(calculationText: String?)
    func tapResultButton()
}

protocol CalculatorPresenterOutput: AnyObject {
    func updateCalculationResult(resultText: String)
    func updateFormula(formulaText: String)
}

final class CalculatorPresenter: CalculatorPresenterInput {
    
    private(set) var currentResultNumber: Double = 0
    private(set) var numberOfResultNumberDesimal: Double = 0
    
    private(set) var currentFormulaText: String = ""
    
    private(set) var switchInputDecimal: Bool = false
    
    private weak var view: CalculatorPresenterOutput!
    
    init(view: CalculatorPresenterOutput) {
        self.view = view
    }
    
    func tapNumberButton(numberText: String?) {
        guard var resultText = numberText else { return }
        
        if switchInputDecimal {
            numberOfResultNumberDesimal += 1
            currentResultNumber = currentResultNumber + Double(resultText)! * pow(0.1, numberOfResultNumberDesimal)
        } else {
            currentResultNumber = currentResultNumber * 10 + Double(resultText)!
        }

        currentFormulaText += String(resultText)
        resultText = String(currentResultNumber)
        resultText = modifiedResultTextFromDouble(resultText: resultText)
        
        self.view.updateCalculationResult(resultText: resultText)
        self.view.updateFormula(formulaText: currentFormulaText)
    }
    
    func tapDecimalButton(desimalText: String?) {
        guard let resultText = desimalText else { return }
        
        currentFormulaText += String(resultText)
        switchInputDecimal = true

        self.view.updateFormula(formulaText: currentFormulaText)
    }
    
    func tapClearButton() {
        resetAllFields()
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
    
    func tapCalculationButton(calculationText: String?) {
        guard var resultText = calculationText else { return }
        currentResultNumber = 0
        currentFormulaText += " \(resultText) "
        
        resetDecimalFields()
        
        resultText = String(currentResultNumber)
        resultText = modifiedResultTextFromDouble(resultText: resultText)
        
        self.view.updateCalculationResult(resultText: resultText)
        self.view.updateFormula(formulaText: currentFormulaText)
    }
    
    func tapResultButton() {

        let expression = NSExpression(format: currentFormulaText)
        let result = expression.expressionValue(with: nil, context: nil) as! Double
        
        resetDecimalFields()
        
        let resultText = String(result)
        currentFormulaText = ""
        
        self.view.updateCalculationResult(resultText: resultText)
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
    
    private func resetAllFields() {
        resetResultFields()
        resetDecimalFields()
    }
    
    private func resetResultFields() {
        currentResultNumber = 0
        currentFormulaText = ""
    }
    
    private func resetDecimalFields() {
        numberOfResultNumberDesimal = 0
        switchInputDecimal = false
    }
}
