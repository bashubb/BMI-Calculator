//
//  CalculateViewController.swift
//  BMI Calculator
//
//  Created by Angela Yu on 21/08/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class CalculateViewController: UIViewController {
    
    @IBOutlet var heightLabel: UILabel!
    @IBOutlet var weightLabel: UILabel!

    @IBOutlet var heightSlider: UISlider!
    @IBOutlet var weightSlider: UISlider!
    
    var calculatorBrain = CalculatorBrain()
    var locationFetcher = LocationFetcher()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func heightSlider(_ sender: UISlider) {
        let height = String(format: "%.2f", sender.value)
        heightLabel.text = "\(height)m"
    }
    
    @IBAction func weightSlider(_ sender: UISlider) {
        let weight = String(format:"%.0f", ceil(sender.value))
        weightLabel.text = "\(weight)Kg"
    }
    
    @IBAction func calculatePressed(_ sender: UIButton) {
        let height = heightSlider.value
        let weight = weightSlider.value
        
        // check if there's value to count
        if height == 0.0 || weight == 0 {
            zeroValueAlert()
        } else {
            calculatorBrain.calculateBMI(height: height, weight: weight)
            self.performSegue(withIdentifier: "goToResult", sender: self)
        }
        
        // haptic
        let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
    }
    
    func zeroValueAlert() {
        let title = "Ooops..."
        let message = "You can't weight 0 kilograms or be 0 meters tall! Try again!"
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(ac, animated: true)
        
        // haptic
        let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.warning)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResult" {
            let destinationVC = segue.destination as! ResultsViewController
            destinationVC.bmiValue =  calculatorBrain.getBMIValue()
            destinationVC.advice = calculatorBrain.getAdvice()
            destinationVC.color = calculatorBrain.getColor()
            destinationVC.goLocation = calculatorBrain.getGoLocation()
            destinationVC.locationFetcher = locationFetcher
            
        }
    }
}

