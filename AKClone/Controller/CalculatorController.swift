//
//  ViewController.swift
//  Calculator
//
//  Created by FARHAN IT SOLUTION on 12/04/17.
//
//

import UIKit

class CalculatorController: UIViewController,StoryboardRedirectionProtocol {

    @IBOutlet private var Display: UILabel!
    private var isDigitPressed = false
    private var brain = CalculatorBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        title = "Calculator"
    }
    
    @IBAction private func digitPressed(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if isDigitPressed{
            let displayDigit = Display.text!
            Display.text = displayDigit + digit
        } else {
            Display.text = digit
        }
        isDigitPressed = true
    }
    
    private var displayValue: Double{
        get{
            return Double(Display.text!)!
        } set{
            Display.text = String(newValue)
        }
    }
    
    @IBAction private func PIClicked(_ sender: UIButton) {
        if isDigitPressed{
            brain.setOperand(operand: displayValue)
            isDigitPressed = false
        }
        
        if let operation = sender.currentTitle{
            brain.performOperation(symbol: operation)
        }
        displayValue = brain.result

    }

}

