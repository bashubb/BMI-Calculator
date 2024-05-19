//
//  ResultsViewController.swift
//  BMI Calculator
//
//  Created by HubertMac on 15/05/2024.
//  Copyright © 2024 Angela Yu. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    
    var bmiValue: String?
    var advice: String?
    var color: UIColor?
    
    @IBOutlet var bmiLabel: UILabel!
    @IBOutlet var backGround: UIImageView!
    @IBOutlet var adviceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bmiLabel.text = bmiValue
        adviceLabel.text = advice
        backGround.backgroundColor = color
        // Do any additional setup after loading the view.
    }
    
    @IBAction func recalculatePressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
