
//
//  Calculator Brain.swift
//  AKClone
//
//  Created by Akash on 16/11/17.
//  Copyright © 2017 Akash. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    
    private var accumulator = 0.0
    
    func setOperand(operand: Double) -> Void {
        accumulator = operand
    }
    
    private var operations: [String: Operation] = [
        "π" : Operation.Constant(.pi), //M_PI,
        "e" : Operation.Constant(M_E), //M_E,
        "√" : Operation.UnaryOperator(sqrt), //sqrt,
        "cos" : Operation.UnaryOperator(cos),//cos
        "×" : Operation.BinaryOperators({$0 * $1 }),
        "+" : Operation.BinaryOperators({$0 + $1 }),//cos
        "-" : Operation.BinaryOperators({$0 - $1 }),//cos
        "÷" : Operation.BinaryOperators({$0 / $1 }),//cos
        "=" : Operation.Equals
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperator((Double) -> Double)
        case BinaryOperators((Double , Double) -> Double)
        case Equals
    }
    
    func performOperation(symbol: String) -> Void {
        if let operation = operations[symbol]{
            switch operation {
            case .Constant(let value):
                accumulator = value
            case .UnaryOperator(let function):
                accumulator = function(accumulator)
            case .BinaryOperators(let function):
                execuPependingBinartOperation()
                pending = PendingBinaryOperatorInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                execuPependingBinartOperation()
            }
        }
    }
    
    private func execuPependingBinartOperation(){
        if pending != nil{
            accumulator = (pending?.binaryFunction((pending?.firstOperand)!, accumulator))!
            pending = nil
        }
    }
    
    private var pending : PendingBinaryOperatorInfo?
    
    private struct PendingBinaryOperatorInfo {
        var binaryFunction: (Double,Double) -> Double
        var firstOperand: Double
    }
    
    var result: Double{
        get{
            return accumulator
        }
    }
    
}
