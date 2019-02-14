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
}

protocol CalculatorPresenterOutput: AnyObject {
    func updateCalculationResult(resultText: String)
}

final class CalculatorPresenter: CalculatorPresenterInput {

    private(set) var currentResultNumber: Int = 0
    
    private weak var view: CalculatorPresenterOutput!
    
    init(view: CalculatorPresenterOutput) {
        self.view = view
    }
    
    func tapNumberButton(numberText: String?) {
        guard var resultText = numberText else { return }
        
        currentResultNumber = currentResultNumber * 10 + Int(resultText)!
        resultText = String(currentResultNumber)
        
        self.view.updateCalculationResult(resultText: resultText)
    }
    
    func tapClearButton() {
        currentResultNumber = 0
        let resultTect = String(currentResultNumber)
        
        self.view.updateCalculationResult(resultText: resultTect)
    }
    
    func tapBackButton() {
        currentResultNumber = currentResultNumber / 10
        let resultTect = String(currentResultNumber)
        
        self.view.updateCalculationResult(resultText: resultTect)
    }
}
