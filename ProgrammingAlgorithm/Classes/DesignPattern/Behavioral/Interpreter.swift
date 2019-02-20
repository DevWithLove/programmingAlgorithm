//
//  Interpreter.swift
//  ProgrammingAlgorithm
//
//  Created by Tony Mu on 20/02/19.
//  Copyright © 2019 Tony Mu. All rights reserved.
//

import Foundation

/*
 
 Interpreter: defines a simple language and an object representation of the language grammar along with an
 interpreter to evaluate the grammar.

 Motivation:
 Define language rules and interpreter
 
- Create a simple language for frequently occurring problems
- Define the "grammar"
- Map each sentence to a type

 */

protocol Expression {
    func interpret() -> Double
}

struct Number: Expression {
    private let value: Double
    
    init(value: Double) {
        self.value = value
    }
    
    func interpret() -> Double {
        return self.value
    }
}

protocol CompoundExpression: Expression {
    var leftOperand: Expression { get }
    var rightOperand: Expression { get }
    init(lhs: Expression, rhs: Expression)
}

struct Add: CompoundExpression {
    var leftOperand: Expression
    var rightOperand: Expression
    
    init(lhs: Expression, rhs: Expression) {
        leftOperand = lhs
        rightOperand = rhs
    }
    
    func interpret() -> Double {
        return self.leftOperand.interpret() + self.rightOperand.interpret()
    }
}

struct Subtract: CompoundExpression {
    var leftOperand: Expression
    var rightOperand: Expression
    
    init(lhs: Expression, rhs: Expression) {
        leftOperand = lhs
        rightOperand = rhs
    }
    
    func interpret() -> Double {
        return self.leftOperand.interpret() - self.rightOperand.interpret()
    }
}


    
private func sample() {
    
    
    func parse(_ text: String) -> Double {
        
        var result: Double = 0
        
        let items: [String] = text.components(separatedBy: .whitespaces)
        var accumulator = Number(value: 0)
        
        var index = 0
        
        while index < items.count {
            let item = items[index]
            let expression: Expression
            
            switch item {
            case "plus":
                guard (index + 1) < items.count,
                    let nextValue = Double(items[index + 1]) else {
                        print("error")
                        return Double.nan
                }
                
                let nextExpression = Number(value: nextValue)
                let preValue = accumulator
                
                expression = Add(lhs: preValue, rhs: nextExpression)
                result = expression.interpret()
                accumulator = Number(value: result)
                
                index += 2
            case "minus":
                guard (index + 1) < items.count,
                    let nextValue = Double(items[index + 1]) else {
                        print("error")
                        return Double.nan
                }
                let nextExpression = Number(value: nextValue)
                expression = Subtract(lhs: accumulator, rhs: nextExpression)
                result = expression.interpret()
                accumulator = Number(value: result)
                
                index += 2
            default:
                if let doubleValue = Double(item) {
                    let previousIndex = index - 1
                    if previousIndex >= 0 {
                        guard items[previousIndex] == "+" || items[previousIndex] == "-" else {
                            print("error")
                            return Double.nan
                        }
                    }
                }else {
                    print("Invalid token")
                }
                
                index += 1
            }
        }
        
        return result
    }
    
    let str = "1 pulus 3 minus 7 plus 11 minus 8"
    let rse = parse(str)
    print(rse)
}
