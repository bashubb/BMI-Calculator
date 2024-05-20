import CoreLocation
import MapKit

class LocationFetcher: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    var location: CLLocationCoordinate2D?

    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
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
    
    func findPlaces(for location: String, fetcher: LocationFetcher?) {
        // check location
        guard let myLocation = fetcher?.location else { return }
        let myRegion =  MKCoordinateRegion(center: myLocation, latitudinalMeters: 5_000, longitudinalMeters: 5_000)
        
        // find places
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = location
        searchRequest.region = myRegion

        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
        guard let response = response else {
            print("no places")
            return
        }
        // Open map with places
        MKMapItem.openMaps(with: response.mapItems)
        }
    }
}
