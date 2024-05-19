import CoreLocation

class LocationFetcher: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    var location: CLLocationCoordinate2D?

    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        print("Requested authorization")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            // Authorization not determined yet
            print("Authorization not determined")
        case .restricted, .denied:
            // Authorization denied or restricted
            print("Authorization denied or restricted")
        case .authorizedWhenInUse, .authorizedAlways:
            // Authorization granted
            if CLLocationManager.locationServicesEnabled() {
                manager.startUpdatingLocation()
                print("Started updating location")
            } else {
                print("Location services are not enabled")
            }
        @unknown default:
            // Handle future cases
            print("Unknown authorization status")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
        if let latitude = location?.latitude, let longitude = location?.longitude {
            print("Location updated: \(latitude), \(longitude)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
}
