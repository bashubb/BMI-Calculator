//
//  CalculatorBrain.swift
//  BMI Calculator
//
//  Created by HubertMac on 15/05/2024.

import MapKit
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
    
    func getGoLocation() -> String? {
        bmi?.goLocation ?? nil
    }
    
    mutating func calculateBMI(height: Float, weight: Float) {
        let bmiValue = weight / pow(height, 2)
        var advice = ""
        var color = UIColor.white
        var goLocation: String?
        
        switch bmiValue {
        case ..<18.5:
            advice = "Eat more!"
            color = #colorLiteral(red: 0.4549019608, green: 0.7254901961, blue: 1, alpha: 1)
            goLocation = "Fast food"
        case 18.5...24.9:
            advice = "You're doing just fine!"
            color = #colorLiteral(red: 0, green: 0.7215686275, blue: 0.5803921569, alpha: 1)
        case 25...:
            advice = "It's time to move!"
            color = #colorLiteral(red: 0.5764705882, green: 0.003921568627, blue: 0.2352941176, alpha: 1)
            goLocation = "Gym"
        default:
            break
        }
        
        bmi = BMI(value: bmiValue, advice: advice, color: color, goLocation: goLocation)
    }
}
