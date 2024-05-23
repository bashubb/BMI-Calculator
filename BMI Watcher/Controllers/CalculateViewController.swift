//
//  CalculateViewController.swift
//  BMI Calculator
//

import UIKit

class CalculateViewController: UIViewController {
    
    @IBOutlet var helpButon: UIButton!
    @IBOutlet var heightLabel: UILabel!
    @IBOutlet var weightLabel: UILabel!

    @IBOutlet var heightSlider: UISlider!
    @IBOutlet var weightSlider: UISlider!
    
    var calculatorBrain = CalculatorBrain()
    var locationFetcher = LocationFetcher()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setHelpButtonUI()
    }
    
    @IBAction func helpButtonPressed(_ sender: UIButton) {
    
        let title = "Info"
        let info = """
        BMI Watcher calculate BMI according to the formula
        BMI = (kg/m2)
        underweight < 18.5
        normal weight 18.5 - 24.9
        overweight > 25
        """
       
        let ac = UIAlertController(title: title, message: info, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        ac.addAction(UIAlertAction(title: "More info", style: .default, handler: moreInfoLink))
        self.present(ac, animated: true)
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
    
    func moreInfoLink(action: UIAlertAction! = nil) {
        let url = URL(string: "https://en.wikipedia.org/wiki/Body_mass_index")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    func setHelpButtonUI() {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale:.medium)
        let helpButtonImage = UIImage(systemName: "questionmark.circle", withConfiguration: imageConfig)
        helpButon.setImage(helpButtonImage, for: .normal)
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

