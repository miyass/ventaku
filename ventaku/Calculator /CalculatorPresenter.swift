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
    //結果欄で小数点を入力しているかどうか
    private(set) var isInputtedDecimal: Bool = false
    //数字が結果欄に入力されているかどうか
    private(set) var isStartedInputNumber: Bool = false
    //=を押して結果を表示しているかどうか
    private(set) var isResulted: Bool = false
    //(が計算式でスタートしているかどうか
    private(set) var isRoundBracketsStarted: Bool = false
    
    private weak var view: CalculatorPresenterOutput!
    
    init(view: CalculatorPresenterOutput) {
        self.view = view
    }
    
    func tapNumberButton(numberText: String?) {
        guard var resultText = numberText else { return }
        
        let formulaTextEnd = currentFormulaText.suffix(1)
        
        if isResulted { return }
        if formulaTextEnd.hasSuffix(")") { return }
        
        
        if isInputtedDecimal {
            numberOfResultNumberDesimal += 1
            currentResultNumber = currentResultNumber + Double(resultText)! * pow(0.1, numberOfResultNumberDesimal)
        } else {
            currentResultNumber = currentResultNumber * 10 + Double(resultText)!
        }
        
        if isStartedInputNumber {
            currentFormulaText += resultText
        } else {
            currentFormulaText += " \(resultText)"
        }
        
        isStartedInputNumber = true
        
        resultText = String(currentResultNumber)
        resultText = modifiedResultTextFromDouble(resultText: resultText)
        
        self.view.updateCalculationResult(resultText: resultText)
        self.view.updateFormula(formulaText: currentFormulaText)
    }
    
    func tapDecimalButton(desimalText: String?) {
        guard let resultText = desimalText else { return }
//        if isInputtedDecimal { return }
//        if !isStartedInputNumber { return }
        
        let formulaTextEnd = currentFormulaText.suffix(1)
        let formulaEndNumber = Int(formulaTextEnd)
        if formulaEndNumber == nil { return }
        if isResulted { return }
        
        currentFormulaText += resultText
        isInputtedDecimal = true
        
        self.view.updateFormula(formulaText: currentFormulaText)
    }
    
    func tapResultButton() {
        //ここでバリデーション書くか
        
        if !isStartedInputNumber { return }
        if isRoundBracketsStarted { return }
        
        let expression = NSExpression(format: currentFormulaText)
        let result = expression.expressionValue(with: nil, context: nil) as! Double
        
        numberOfResultNumberDesimal = 0
        isInputtedDecimal = false
        isStartedInputNumber = false
        isRoundBracketsStarted = false
        
        var resultText = String(result)
        if resultText.hasSuffix(".0") {
            resultText = String(resultText.prefix(resultText.characters.count - 2))
        }
        currentFormulaText = " \(resultText)"
        
        isResulted = true
        
        self.view.updateCalculationResult(resultText: resultText)
        self.view.updateFormula(formulaText: currentFormulaText)
    }
    
    func tapCalculationButton(calculationCount: Int) {
        let formulaTextEnd = currentFormulaText.suffix(1)
        let formulaEndNumber = Int(formulaTextEnd)
        
        if formulaTextEnd.hasSuffix(")") || formulaEndNumber != nil {
            let calculationSymbolText = ["=", "+", "-", "*", "/"]
            var resultText = calculationSymbolText[calculationCount]
            currentResultNumber = 0
            currentFormulaText += " \(resultText)"
            
            numberOfResultNumberDesimal = 0
            isInputtedDecimal = false
            isStartedInputNumber = false
            isResulted = false
            
            resultText = String(currentResultNumber)
            resultText = modifiedResultTextFromDouble(resultText: resultText)
            
            self.view.updateCalculationResult(resultText: resultText)
            self.view.updateFormula(formulaText: currentFormulaText)
        } else {
            return
        }
    }
    
    func tapStartRoundBrackets(startRoundBrackets: String?) {
        guard let startRoundBracketsText = startRoundBrackets else { return }
        
        if isRoundBracketsStarted { return }
        if isStartedInputNumber { return }
        if isResulted { return }
        
        currentFormulaText += " \(startRoundBracketsText)"
        
        isRoundBracketsStarted = true
        
        self.view.updateFormula(formulaText: currentFormulaText)
    }
    
    func tapEndRoundBrackets(endRoundBrackets: String?) {
        guard let endRoundBracketsText = endRoundBrackets else { return }
        
        if !isRoundBracketsStarted { return }
        if !isStartedInputNumber { return }
        
        currentResultNumber = 0
        currentFormulaText += " \(endRoundBracketsText)"
        
        let resultText = String(currentResultNumber)
        
        isRoundBracketsStarted = false
        isStartedInputNumber = false
        
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
        isRoundBracketsStarted = false
        var resultText = String(currentResultNumber)
        
        resultText = modifiedResultTextFromDouble(resultText: resultText)
        
        self.view.updateCalculationResult(resultText: resultText)
        self.view.updateFormula(formulaText: currentFormulaText)
    }
    
    func tapBackButton() {
        var splitFormulaTexts = currentFormulaText.components(separatedBy: " ")
        let removeLastFormulaText = splitFormulaTexts[splitFormulaTexts.count - 1]
        let removeLastFormulaNumber = Float(removeLastFormulaText)
    
        splitFormulaTexts.removeLast()
        
        if removeLastFormulaText == ")" {
            //)消した後の数字に続けていける
            isRoundBracketsStarted = true
            isStartedInputNumber = true
            //あまり良くないかも
            isResulted = true
        } else if removeLastFormulaText == "(" {
            isRoundBracketsStarted = false
            isStartedInputNumber = false
        } else if removeLastFormulaNumber != nil {
            //resultを消す可能性も考慮せよ
            isStartedInputNumber = false
            isResulted = false
            isInputtedDecimal = false
        } else if removeLastFormulaNumber == nil {
            //あまり良くないかも
            isStartedInputNumber = true
            isResulted = true
        }
        
        currentResultNumber = 0
        currentFormulaText = ""
        for splitFormulaText  in splitFormulaTexts {
            currentFormulaText += " \(splitFormulaText)"
        }
        
        var resultText = String(currentResultNumber)
        resultText = modifiedResultTextFromDouble(resultText: resultText)
    
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
