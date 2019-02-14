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
    
    private(set) var currentResultNumber: Int = 0
    private(set) var currentFormulaText: String = ""
    
    private weak var view: CalculatorPresenterOutput!
    
    init(view: CalculatorPresenterOutput) {
        self.view = view
    }
    
    func tapNumberButton(numberText: String?) {
        guard var resultText = numberText else { return }
        
        currentResultNumber = currentResultNumber * 10 + Int(resultText)!
        currentFormulaText += String(resultText)
        
        resultText = String(currentResultNumber)
        
        self.view.updateCalculationResult(resultText: resultText)
        self.view.updateFormula(formulaText: currentFormulaText)
    }
    
    func tapClearButton() {
        currentResultNumber = 0
        let resultTect = String(currentResultNumber)
        currentFormulaText = ""
        
        self.view.updateCalculationResult(resultText: resultTect)
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
        currentFormulaText += resultText
        resultText = String(currentResultNumber)
        
        self.view.updateCalculationResult(resultText: resultText)
        self.view.updateFormula(formulaText: currentFormulaText)
    }
    
    func tapResultButton() {
//        let testFormula: String = "(4.0 + 5) * 40 - (-50)"
        let expression = NSExpression(format: currentFormulaText)
        let result = expression.expressionValue(with: nil, context: nil) as! Double
        
        let resultText = String(result)
        currentFormulaText = ""
        self.view.updateCalculationResult(resultText: resultText)
        self.view.updateFormula(formulaText: currentFormulaText)

    }
    
}
