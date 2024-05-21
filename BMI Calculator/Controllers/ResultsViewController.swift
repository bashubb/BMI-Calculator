//
//  ResultsViewController.swift
//  BMI Calculator
//
//  Created by HubertMac on 15/05/2024.
//  Copyright © 2024 Angela Yu. All rights reserved.
//

import MapKit
import UIKit
import CoreHaptics
import NotificationCenter

class ResultsViewController: UIViewController {
    
    var bmiValue: String?
    var advice: String?
    var color: UIColor?
    var engine: CHHapticEngine?
    
    var goLocation: String?
    var locationFetcher: LocationFetcher?
    private var observer: NSObjectProtocol?
    
    @IBOutlet var bmiLabel: UILabel!
    @IBOutlet var adviceLabel: UILabel!
    @IBOutlet var goToLocationButtonLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        if goLocation == "Gym" {
            // play haptic
            generateVibration()
        }
        
        observer = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [unowned self] notification in
            self.setUI()
        }
    }
    
    deinit {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    func setUI() {
        view.backgroundColor = color
        
        setGoToLocationButtonLabel()
        goToLocationButtonLabel.layer.cornerRadius =  8
        
        bmiLabel.text = bmiValue
        adviceLabel.text = advice
    }
    
    // go back
    @IBAction func recalculatePressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    //fetch places and go to the maps
    @IBAction func GoLocationButton(_ sender: UIButton) {
        guard let goLocation else { return }
        if locationFetcher?.manager.authorizationStatus == .denied ||
            locationFetcher?.manager.authorizationStatus == .notDetermined {
            openSettings()
        } else {
            // find places and open the Map
            locationFetcher!.findPlaces(for: goLocation, fetcher: locationFetcher)
        }
    }
    
     func goLocationButtonTitle() -> String {
        let status = locationFetcher?.manager.authorizationStatus
         
         switch status {
         case .authorizedAlways, .authorizedWhenInUse:
             if goLocation == "Gym" {
                 return "Find a GYM!"
             } else {
                 return "Find a FAST FOOD !"
             }
         case .none, .some(.notDetermined), .some(.restricted), .some(.denied), .some(_):
            return "Enable Locations"
         }
    }
    
    func setGoToLocationButtonLabel() {
        if  goLocation == nil  {
            goToLocationButtonLabel.isHidden = true
        } else {
            goToLocationButtonLabel.setTitle(goLocationButtonTitle(), for: .normal)
        }
    }
    
    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    func generateVibration() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
        
        var events = [CHHapticEvent]()
        var curves = [CHHapticParameterCurve]()
        
        // create a dull, strong haptic
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0)
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 2)
        
        // create a curve that fades from 1 to 0.2 over three second
        let start = CHHapticParameterCurve.ControlPoint(relativeTime: 0, value: 1)
        let end = CHHapticParameterCurve.ControlPoint(relativeTime: 3.0, value: 0.2)
        
        // create a continuous haptic event starting immediately and lasting three second
        let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [sharpness, intensity], relativeTime: 0, duration: 3)
        let parameter = CHHapticParameterCurve(parameterID: .hapticIntensityControl, controlPoints: [start, end], relativeTime: 0)
        events.append(event)
        curves.append(parameter)
        
        for _ in 1...24 {
            // make some sparkles
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [sharpness, intensity], relativeTime: TimeInterval.random(in: 0.1...1))
            events.append(event)
        }
        
        // now attempt to play the haptic, with our fading parameter
        do {
            let pattern = try CHHapticPattern(events: events, parameterCurves: curves)
            
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print(error.localizedDescription)
        }
    }
}


