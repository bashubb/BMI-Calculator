//
//  ResultsViewController.swift
//  BMI Calculator
//
//  Created by HubertMac on 15/05/2024.
//  Copyright © 2024 Angela Yu. All rights reserved.
//

import MapKit
import UIKit

class ResultsViewController: UIViewController {
    
    var bmiValue: String?
    var advice: String?
    var color: UIColor?
    var goLocation: String?
    var locationFetcher: LocationFetcher?
    
    var goLocationButtonTitle: String {
        if goLocation == "Gym" {
            return "Find a GYM!"
        } else {
            return "Find a FASTFOOD !"
        }
    }
    
    @IBOutlet var bmiLabel: UILabel!
    @IBOutlet var backGround: UIImageView!
    @IBOutlet var adviceLabel: UILabel!
    @IBOutlet var goToLocationButtonLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goToLocationButtonLabel.layer.cornerRadius =  8
        
        bmiLabel.text = bmiValue
        adviceLabel.text = advice
        view.backgroundColor = color
        
        if goLocation != nil {
            goToLocationButtonLabel.setTitle(goLocationButtonTitle, for: .normal)
        } else {
            goToLocationButtonLabel.isHidden = true
        }
    }
    
    @IBAction func recalculatePressed(_ sender: UIButton) {
        dismiss(animated: true)
            
    }
    
    @IBAction func GoLocationButton(_ sender: UIButton) {
        guard let goLocation else { return }
        findPlaces(for: goLocation)
    }
    
    
    func findPlaces(for location: String) {
        guard let myLocation = locationFetcher?.location else { return }
        let myRegion =  MKCoordinateRegion(center: myLocation, latitudinalMeters: 5_000, longitudinalMeters: 5_000)
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = location
        
        // Set the region to an associated map view's region.
        searchRequest.region = myRegion

        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard let response = response else {
                print("no places")
                return
            }
            
        MKMapItem.openMaps(with: response.mapItems)
        }
    }
    
}


