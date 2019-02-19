//
//  ViewController.swift
//  ventaku
//
//  Created by 宮倉宗平 on 2019/02/12.
//  Copyright © 2019 Sohei Miyakura. All rights reserved.
//

import UIKit
import SnapKit

final class CalculatorViewController: UIViewController, UITextFieldDelegate {
    
    private var presenter:CalculatorPresenter!
    
    private let calculationResultTextField = UITextField()
    private let formulaTextLabel = UILabel()
    
    private let buttonBottomMargin: CGFloat = 30.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = CalculatorPresenter(view: self)
        
        calculationResultTextField.delegate = self
        designSetUp()
    }
}

//For design
extension CalculatorViewController {
    private func designSetUp() {
        createNumberButton()
        createCalculationButton()
        createCalculationResultArea()
        createTopFunctionalButton()
        createBottomFunctionalButton()
    }
    //数字ボタン
    private func createNumberButton() {
        var numberCount = 0
        while numberCount <= 9 {
            let numberButton = UIButton(type: .custom)
            view.addSubview(numberButton)
            numberButton.addTarget(self, action: #selector(tapNumberButton), for: .touchUpInside)
            configureNumberDesignPosition(numberButton: numberButton, number: numberCount)
            configureEachNumberButtonDesign(numberButton: numberButton, number: numberCount)
            numberCount += 1
        }
    }
    //計算記号ボタン
    private func createCalculationButton() {
        var calculateCount = 0
        while calculateCount <= 4 {
            let calculationButton = UIButton(type: .custom)
            view.addSubview(calculationButton)
            if calculateCount == 0 {
                calculationButton.addTarget(self, action: #selector(tapResultButton), for: .touchUpInside)
            } else {
                calculationButton.tag = calculateCount
                calculationButton.addTarget(self, action: #selector(tapCalculationButton), for: .touchUpInside)
            }
            configureCalculationDesignPosition(calculationButton: calculationButton, calculateCount: calculateCount)
            configureEachCalculationButtonDesign(calculationButton: calculationButton, calculateCount: calculateCount)
            calculateCount += 1
        }
    }
    //計算結果エリア
    private func createCalculationResultArea() {
        let calculationResultArea = UIView()
        view.addSubview(calculationResultArea)
//        calculationResultArea.backgroundColor = UIColor.init(red: 196 / 252, green: 196 / 252, blue: 196 / 252, alpha: 252 / 252)
        calculationResultArea.snp.makeConstraints{ make in
            make.width.equalTo(view.bounds.width)
            make.height.equalTo(view.bounds.width / 3.5)
            make.bottom.equalTo(view).offset(view.bounds.width / 4 * -5 - buttonBottomMargin)
        }
        createCalculationResultTextField(calculationResultArea: calculationResultArea)
        createFormulaText(calculationResultArea: calculationResultArea)
        createBackButton(calculationResultArea: calculationResultArea)
    }
    //計算結果テキスト
    private func createCalculationResultTextField(calculationResultArea: UIView) {
        calculationResultArea.addSubview(calculationResultTextField)
        configureCalculationResultTextFieldPosition(calculationResultTextField: calculationResultTextField, calculationResultArea: calculationResultArea)
        configureCalculationResultTextFieldDesign(calculationResultTextField: calculationResultTextField)
    }
    //計算式テキスト
    private func createFormulaText(calculationResultArea: UIView) {
        calculationResultArea.addSubview(formulaTextLabel)
        configureFormulaTextPosition(formulaTextLabel: formulaTextLabel, calculationResultArea: calculationResultArea)
        congifureFormulaTextDesign(formulaTextLabel: formulaTextLabel)
    }
    //戻るボタン
    private func createBackButton(calculationResultArea: UIView) {
        let backButton = UIButton(type: .custom)
        backButton.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
        calculationResultArea.addSubview(backButton)
        configureBackButtonPosition(backButton: backButton, calculationResultArea: calculationResultArea)
        configureBackButtonDesign(backButton: backButton)
    }
    
    //各種機能ボタン(上段)
    private func createTopFunctionalButton() {
        var functionalButtonCount = 0
        while functionalButtonCount <= 2 {
            let functionalButton = UIButton(type: .custom)
            if functionalButtonCount == 0 {
                functionalButton.addTarget(self, action: #selector(tapDecimalButton), for: .touchUpInside)
            } else if functionalButtonCount == 1 {
                functionalButton.addTarget(self, action: #selector(tapStartRoundBrackets), for: .touchUpInside)
            } else if functionalButtonCount == 2 {
                functionalButton.addTarget(self, action: #selector(tapEndRoundBrackets), for: .touchUpInside)
            }
            view.addSubview(functionalButton)
            configureTopFunctionalButtonPosition(functionalButton: functionalButton, functionalButtonCount: functionalButtonCount)
            configureTopFunctionalButtonDesign(functionalButton: functionalButton, functionalButtonCount: functionalButtonCount)
            functionalButtonCount += 1
        }
    }
    //各種機能ボタン(下段)
    private func createBottomFunctionalButton() {
        var bottomFunctionalButtonCount = 0
        while bottomFunctionalButtonCount <= 1 {
            let bottomFunctionalButton = UIButton(type: .custom)
            if bottomFunctionalButtonCount == 0 {
                bottomFunctionalButton.addTarget(self, action: #selector(tapDecimalButton), for: .touchUpInside)
            } else if bottomFunctionalButtonCount == 1 {
                bottomFunctionalButton.addTarget(self, action: #selector(tapClearButton), for: .touchUpInside)
            }
            view.addSubview(bottomFunctionalButton)
            configureBottomFunctionalButtonPosition(bottomFunctionalButton: bottomFunctionalButton, bottomFunctionalButtonCount: bottomFunctionalButtonCount)
            configureBottomFunctionalButtonDesign(bottomFunctionalButton: bottomFunctionalButton, bottomFunctionalButtonCount: bottomFunctionalButtonCount)
            bottomFunctionalButtonCount += 1
        }
    }
    
}

extension CalculatorViewController {
    @objc func tapNumberButton(_ sender: UIButton) {
        presenter.tapNumberButton(numberText: sender.currentTitle)
    }
    
    @objc func tapClearButton(_ sender: UIButton) {
        presenter.tapClearButton()
    }
    
    @objc func tapBackButton(_ sender: UIButton) {
        presenter.tapBackButton()
    }
    
    @objc func tapCalculationButton(_ sender: UIButton) {
        presenter.tapCalculationButton(calculationCount: sender.tag)
    }
    
    @objc func tapResultButton(_ sender: UIButton) {
        presenter.tapResultButton()
    }
    
    @objc func tapDecimalButton(_ sender: UIButton) {
        presenter.tapDecimalButton(desimalText: sender.currentTitle)
    }
    
    @objc func tapStartRoundBrackets(_ sender: UIButton) {
        presenter.tapStartRoundBrackets(startRoundBrackets: sender.currentTitle)
    }
    
    @objc func tapEndRoundBrackets(_ sender: UIButton) {
        presenter.tapEndRoundBrackets(endRoundBrackets: sender.currentTitle)
    }
}


extension CalculatorViewController: CalculatorPresenterOutput {
    func updateCalculationResult(resultText: String) {
        calculationResultTextField.text! = resultText
    }
    
    func updateFormula(formulaText: String) {
        formulaTextLabel.text! = formulaText
    }
}


// design detail
extension CalculatorViewController {
    private func configureCalculationDesignPosition(calculationButton: UIButton, calculateCount: Int) {
        calculationButton.snp.makeConstraints{(make) in
            make.width.equalTo(view.bounds.width / 4)
            make.height.equalTo(view.bounds.width / 4)
            make.bottom.equalTo(view).offset(view.bounds.width / 4 * CGFloat(-calculateCount) - buttonBottomMargin)
            make.right.equalTo(view)
        }
    }
    
    private func configureEachCalculationButtonDesign(calculationButton: UIButton, calculateCount: Int) {
        let calculationSymbolImage = [ "=", "+", "-", "×", "÷" ]
        calculationButton.setTitle(calculationSymbolImage[calculateCount], for: .normal)
        calculationButton.setTitleColor(UIColor.black, for: .normal)
        calculationButton.titleLabel!.font = UIFont.init(name: "RobotoCondensed-Bold", size: 48)
        calculationButton.backgroundColor = UIColor.init(red: 26 / 252, green: 161 / 252, blue: 112 / 252, alpha: 252 / 252)
        calculationButton.layer.borderWidth = 2
        calculationButton.layer.borderColor = UIColor.init(red: 81 / 252, green: 89 / 252, blue: 87 / 252, alpha: 252 / 252).cgColor
        
        calculationButton.layer.cornerRadius = view.bounds.width / 16
    }
    
    private func configureNumberDesignPosition(numberButton: UIButton, number: Int) {
        var numberWidthSort: CGFloat = 0.0
        var numberHeightSort: CGFloat = 0.0
        
        if number != 0 {
            numberHeightSort = CGFloat((number - 1) / 3 + 1)
            
            switch number % 3 {
            case 0:
                numberWidthSort = 2.0
            case 1:
                numberWidthSort = 0
            case 2:
                numberWidthSort = 1.0
            default:
                numberWidthSort = 0
            }
        }
        
        numberButton.snp.makeConstraints{(make) in
            make.width.equalTo(view.bounds.width / 4)
            make.height.equalTo(view.bounds.width / 4)
            make.bottom.equalTo(view).offset(view.bounds.width / 4 * -numberHeightSort - buttonBottomMargin)
            make.left.equalTo(view).offset(view.bounds.width / 4 * numberWidthSort)
        }
    }
    
    private func configureEachNumberButtonDesign(numberButton: UIButton, number: Int) {
        numberButton.setTitle(String(number), for: .normal)
        numberButton.titleLabel!.font = UIFont.init(name: "RobotoCondensed-Bold", size: 48)
        numberButton.setTitleColor(UIColor.black, for: .normal)
        numberButton.backgroundColor = UIColor.init(red: 245 / 252, green: 245 / 252, blue: 245 / 252, alpha: 252 / 252)
        numberButton.layer.borderWidth = 2
        numberButton.layer.borderColor = UIColor.init(red: 81 / 252, green: 89 / 252, blue: 87 / 252, alpha: 252 / 252).cgColor
        
        numberButton.layer.cornerRadius = view.bounds.width / 16
    }
    
    private func configureCalculationResultTextFieldPosition(calculationResultTextField: UITextField, calculationResultArea: UIView) {
        calculationResultTextField.snp.makeConstraints { (make) in
            make.width.equalTo(view.bounds.width / 8 * 7)
            make.height.equalTo(view.bounds.width / 4)
            make.top.equalTo(calculationResultArea.snp.top)
            make.right.equalTo(view).offset(view.bounds.width / -8)
        }
    }
    
    private func configureCalculationResultTextFieldDesign(calculationResultTextField: UITextField) {
        calculationResultTextField.text = ""
        calculationResultTextField.textAlignment = .right
        calculationResultTextField.contentVerticalAlignment = .center
        calculationResultTextField.textColor = UIColor.white
        calculationResultTextField.font = UIFont(name: "RobotoCondensed-Bold", size: 48)
        calculationResultTextField.adjustsFontSizeToFitWidth = true
//        calculationResultTextField.backgroundColor = UIColor.red
        
        //入力不可の方法。お気に入り機能からの遷移時には使えるようにする。
        calculationResultTextField.isEnabled = false
    }
    
    private func configureFormulaTextPosition(formulaTextLabel: UILabel, calculationResultArea: UIView) {
        formulaTextLabel.snp.makeConstraints { (make) in
            make.width.equalTo(view.bounds.width / 8 * 7)
            make.height.equalTo(view.bounds.width / 12)
            make.bottom.equalTo(calculationResultArea.snp.bottom)
            make.right.equalTo(view).offset(view.bounds.width / -8)
        }
    }
    
    private func congifureFormulaTextDesign(formulaTextLabel: UILabel) {
        formulaTextLabel.text = ""
        formulaTextLabel.textAlignment = .right
        formulaTextLabel.textColor = UIColor.gray
        formulaTextLabel.font = UIFont(name: "RobotoCondensed-Bold", size: 24)
        formulaTextLabel.adjustsFontSizeToFitWidth = true
//        formulaTextLabel.backgroundColor = UIColor.green
    }
    
    private func configureBackButtonPosition(backButton: UIButton, calculationResultArea: UIView) {
        backButton.snp.makeConstraints { (make) in
            make.width.equalTo(view.bounds.width / 8)
            make.height.equalTo(view.bounds.width / 4)
            make.right.equalTo(calculationResultArea)
        }
    }
    
    private func configureBackButtonDesign(backButton: UIButton) {
        backButton.setTitle("<", for: .normal)
        backButton.setTitleColor(UIColor.white, for: .normal)
        backButton.titleLabel!.font = UIFont.init(name: "RobotoCondensed-Bold", size: 40)
        backButton.contentVerticalAlignment = .center
//        backButton.backgroundColor = UIColor.init(red: 90 / 252, green: 180 / 252, blue: 139 / 252, alpha: 252 / 252)
    }
    
    private func configureTopFunctionalButtonPosition(functionalButton: UIButton, functionalButtonCount: Int) {
        functionalButton.snp.makeConstraints { (make) in
            make.width.equalTo(view.bounds.width / 4)
            make.height.equalTo(view.bounds.width / 4)
            make.bottom.equalTo(view.bounds.width / 4 * -4 - buttonBottomMargin)
            make.left.equalTo(view.bounds.width / 4 * CGFloat(functionalButtonCount))
        }
    }
    
    private func configureTopFunctionalButtonDesign(functionalButton: UIButton, functionalButtonCount: Int) {
        let functionalSymbolImage = [ "+/-", "(", ")" ]
        functionalButton.setTitle(functionalSymbolImage[functionalButtonCount], for: .normal)
        functionalButton.setTitleColor(UIColor.black, for: .normal)
        functionalButton.titleLabel!.font = UIFont.init(name: "RobotoCondensed-Bold", size: 48)
        functionalButton.backgroundColor = UIColor.init(red: 90 / 252, green: 180 / 252, blue: 139 / 252, alpha: 252 / 252)
        functionalButton.layer.borderWidth = 2
        functionalButton.layer.borderColor = UIColor.init(red: 81 / 252, green: 89 / 252, blue: 87 / 252, alpha: 252 / 252).cgColor
        
        functionalButton.layer.cornerRadius = view.bounds.width / 16
    }
    
    private func configureBottomFunctionalButtonPosition(bottomFunctionalButton: UIButton, bottomFunctionalButtonCount: Int) {
        bottomFunctionalButton.snp.makeConstraints { (make) in
            make.width.equalTo(view.bounds.width / 4)
            make.height.equalTo(view.bounds.width / 4)
            make.bottom.equalTo(view).offset(-buttonBottomMargin)
            make.left.equalTo(view.bounds.width / 4 * CGFloat(bottomFunctionalButtonCount + 1))
        }
    }
    
    private func configureBottomFunctionalButtonDesign(bottomFunctionalButton: UIButton, bottomFunctionalButtonCount: Int) {
        let eraceSymbolImage = [".", "C"]
        bottomFunctionalButton.setTitle(eraceSymbolImage[bottomFunctionalButtonCount], for: .normal)
        bottomFunctionalButton.setTitleColor(UIColor.black, for: .normal)
        bottomFunctionalButton.titleLabel!.font = UIFont.init(name: "RobotoCondensed-Bold", size: 48)
        bottomFunctionalButton.backgroundColor = UIColor.init(red: 245 / 252, green: 245 / 252, blue: 245 / 252, alpha: 252 / 252)
        bottomFunctionalButton.layer.borderWidth = 2
        bottomFunctionalButton.layer.borderColor = UIColor.init(red: 81 / 252, green: 89 / 252, blue: 87 / 252, alpha: 252 / 252).cgColor
        
        bottomFunctionalButton.layer.cornerRadius = view.bounds.width / 16
    }
}
