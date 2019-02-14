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
    private let formulaText = UILabel()
    
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
        createFunctionalButton()
        createEraceButton()
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
            configureCalculationDesignPosition(calculationButton: calculationButton, calculateCount: calculateCount)
            configureEachCalculationButtonDesign(calculationButton: calculationButton, calculateCount: calculateCount)
            calculateCount += 1
        }
    }
    //計算結果エリア
    private func createCalculationResultArea() {
        let calculationResultArea = UIView()
        view.addSubview(calculationResultArea)
        calculationResultArea.backgroundColor = UIColor.init(red: 196 / 252, green: 196 / 252, blue: 196 / 252, alpha: 252 / 252)
        calculationResultArea.snp.makeConstraints{ make in
            make.width.equalTo(view.bounds.width)
            make.height.equalTo(view.bounds.width / 4)
            make.bottom.equalTo(view).offset(view.bounds.width / 4 * -5)
        }
        createCalculationResultTextField(calculationResultArea: calculationResultArea)
        createFormulaText(calculationResultArea: calculationResultArea)
    }
    //計算結果テキスト
    private func createCalculationResultTextField(calculationResultArea: UIView) {
        calculationResultArea.addSubview(calculationResultTextField)
        configureCalculationResultTextFieldPosition(calculationResultTextField: calculationResultTextField, calculationResultArea: calculationResultArea)
        configureCalculationResultTextFieldDesign(calculationResultTextField: calculationResultTextField)
    }
    //計算式テキスト
    private func createFormulaText(calculationResultArea: UIView) {
        calculationResultArea.addSubview(formulaText)
        configureFormulaTextPosition(formulaText: formulaText, calculationResultArea: calculationResultArea)
        congifureFormulaTextDesign(formulaText: formulaText)
    }
    //各種機能ボタン
    private func createFunctionalButton() {
        var functionalButtonCount = 0
        while functionalButtonCount <= 2 {
            let functionalButton = UIButton(type: .custom)
            view.addSubview(functionalButton)
            configureFunctionalButtonPosition(functionalButton: functionalButton, functionalButtonCount: functionalButtonCount)
            configureFunctionalButtonDesign(functionalButton: functionalButton, functionalButtonCount: functionalButtonCount)
            functionalButtonCount += 1
        }
    }
    //削除、戻るボタン
    private func createEraceButton() {
        var eraceButtonCount = 0
        while eraceButtonCount <= 1 {
            let eraceButton = UIButton(type: .custom)
            if eraceButtonCount == 0 {
                eraceButton.addTarget(self, action: #selector(clearButton), for: .touchUpInside)
            } else if eraceButtonCount == 1 {
                eraceButton.addTarget(self, action: #selector(backButton), for: .touchUpInside)
            }
            view.addSubview(eraceButton)
            configureEraceButtonPosition(eraceButton: eraceButton, eraceButtonCount: eraceButtonCount)
            configureEraceButtonDesign(eraceButton: eraceButton, eraceButtonCount: eraceButtonCount)
            eraceButtonCount += 1
        }
    }
    
}

extension CalculatorViewController {
    @objc func tapNumberButton(_ sender: UIButton) {
        presenter.tapNumberButton(numberText: sender.currentTitle)
    }
    
    @objc func clearButton(_ sender: UIButton) {
        presenter.tapClearButton()
    }
    
    @objc func backButton(_ sender: UIButton) {
        presenter.tapBackButton()
    }
    
}


extension CalculatorViewController: CalculatorPresenterOutput {
    func updateCalculationResult(resultText: String) {
        calculationResultTextField.text! = resultText
    }
}


// design detail
extension CalculatorViewController {
    private func configureCalculationDesignPosition(calculationButton: UIButton, calculateCount: Int) {
        calculationButton.snp.makeConstraints{(make) in
            make.width.equalTo(view.bounds.width / 4)
            make.height.equalTo(view.bounds.width / 4)
            make.bottom.equalTo(view).offset(view.bounds.width / 4 * CGFloat(-calculateCount))
            make.right.equalTo(view)
        }
    }
    
    private func configureEachCalculationButtonDesign(calculationButton: UIButton, calculateCount: Int) {
        let calculationSymbolImage = [ "=", "+", "-", "×", "÷" ]
        calculationButton.setTitle(calculationSymbolImage[calculateCount], for: .normal)
        calculationButton.setTitleColor(UIColor.black, for: .normal)
        calculationButton.titleLabel!.font = UIFont.init(name: "RobotoCondensed-Bold", size: 48)
        calculationButton.backgroundColor = UIColor.init(red: 26 / 252, green: 161 / 252, blue: 112 / 252, alpha: 252 / 252)
        calculationButton.layer.borderWidth = 1
        calculationButton.layer.borderColor = UIColor.gray.cgColor
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
            make.bottom.equalTo(view).offset(view.bounds.width / 4 * -numberHeightSort)
            make.left.equalTo(view).offset(view.bounds.width / 4 * numberWidthSort)
        }
    }
    
    private func configureEachNumberButtonDesign(numberButton: UIButton, number: Int) {
        numberButton.setTitle(String(number), for: .normal)
        numberButton.titleLabel!.font = UIFont.init(name: "RobotoCondensed-Bold", size: 48)
        numberButton.setTitleColor(UIColor.black, for: .normal)
        numberButton.backgroundColor = UIColor.init(red: 245 / 252, green: 245 / 252, blue: 245 / 252, alpha: 252 / 252)
        numberButton.layer.borderWidth = 1
        numberButton.layer.borderColor = UIColor.gray.cgColor
    }
    
    private func configureCalculationResultTextFieldPosition(calculationResultTextField: UITextField, calculationResultArea: UIView) {
        calculationResultTextField.snp.makeConstraints { (make) in
            make.width.equalTo(view.bounds.width)
            make.height.equalTo(view.bounds.width / 4)
            make.top.equalTo(calculationResultArea.snp.top)
        }
    }
    
    private func configureCalculationResultTextFieldDesign(calculationResultTextField: UITextField) {
        calculationResultTextField.text = "12,345,667,899"
        calculationResultTextField.textAlignment = .right
        calculationResultTextField.font = UIFont(name: "RobotoCondensed-Bold", size: 40)
//        calculationResultTextField.backgroundColor = UIColor.red
        
        //入力不可の方法。お気に入り機能からの遷移時には使えるようにする。
        calculationResultTextField.isEnabled = false
    }
    
    private func configureFormulaTextPosition(formulaText: UILabel, calculationResultArea: UIView) {
        formulaText.snp.makeConstraints { (make) in
            make.width.equalTo(view.bounds.width)
            make.height.equalTo(view.bounds.width / 12)
            make.bottom.equalTo(calculationResultArea.snp.bottom)
        }
    }
    
    private func congifureFormulaTextDesign(formulaText: UILabel) {
        formulaText.text = "( 3 + 30 - 10) * 10 / 3"
        formulaText.textAlignment = .right
        formulaText.textColor = UIColor.gray
        formulaText.font = UIFont(name: "RobotoCondensed-Bold", size: 16)
//        formulaText.backgroundColor = UIColor.green
    }
    
    private func configureFunctionalButtonPosition(functionalButton: UIButton, functionalButtonCount: Int) {
        functionalButton.snp.makeConstraints { (make) in
            make.width.equalTo(view.bounds.width / 4)
            make.height.equalTo(view.bounds.width / 4)
            make.bottom.equalTo(view.bounds.width / 4 * -4)
            make.left.equalTo(view.bounds.width / 4 * CGFloat(functionalButtonCount))
        }
    }
    
    private func configureFunctionalButtonDesign(functionalButton: UIButton, functionalButtonCount: Int) {
        let functionalSymbolImage = [ "+/-", "(", ")" ]
        functionalButton.setTitle(functionalSymbolImage[functionalButtonCount], for: .normal)
        functionalButton.setTitleColor(UIColor.black, for: .normal)
        functionalButton.titleLabel!.font = UIFont.init(name: "RobotoCondensed-Bold", size: 48)
        functionalButton.backgroundColor = UIColor.init(red: 90 / 252, green: 180 / 252, blue: 139 / 252, alpha: 252 / 252)
        functionalButton.layer.borderWidth = 1
        functionalButton.layer.borderColor = UIColor.gray.cgColor
    }
    
    private func configureEraceButtonPosition(eraceButton: UIButton, eraceButtonCount: Int) {
        eraceButton.snp.makeConstraints { (make) in
            make.width.equalTo(view.bounds.width / 4)
            make.height.equalTo(view.bounds.width / 4)
            make.bottom.equalTo(view)
            make.left.equalTo(view.bounds.width / 4 * CGFloat(eraceButtonCount + 1))
        }
    }
    
    private func configureEraceButtonDesign(eraceButton: UIButton, eraceButtonCount: Int) {
        let eraceSymbolImage = ["C", "<"]
        eraceButton.setTitle(eraceSymbolImage[eraceButtonCount], for: .normal)
        eraceButton.setTitleColor(UIColor.black, for: .normal)
        eraceButton.titleLabel!.font = UIFont.init(name: "RobotoCondensed-Bold", size: 48)
        eraceButton.backgroundColor = UIColor.init(red: 245 / 252, green: 245 / 252, blue: 245 / 252, alpha: 252 / 252)
        eraceButton.layer.borderWidth = 1
        eraceButton.layer.borderColor = UIColor.gray.cgColor
    }
}
