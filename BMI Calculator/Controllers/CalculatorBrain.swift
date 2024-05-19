//
//  CalculatorBrain.swift
//  BMI Calculator
//
//  Created by HubertMac on 15/05/2024.
//  Copyright © 2024 Angela Yu. All rights reserved.
//

import UIKit

struct CalculatorBrain {
    
    var bmi: BMI?
    
    func getBMIValue() -> String {
        String(format: "%.1f", bmi?.value ?? 0.0)
    }
    
    func getAdvice() -> String {
        bmi?.advice ?? ""
    }
    
    func getColor() -> UIColor {
        bmi?.color ?? .clear
    }
    
    mutating func calculateBMI(height: Float, weight: Float) {
        let bmiValue = weight / pow(height, 2)
        var advice = ""
        var color = UIColor.white
        
        switch bmiValue {
        case ..<18.5:
            advice = "Eat more pies!"
            color = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        case 18.5...24.9:
            advice = "Good!"
            color = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        case 25...:
            advice = "To much!"
            color = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        default:
            break
        }
        
        bmi = BMI(value: bmiValue, advice: advice, color: color)
    }
}
