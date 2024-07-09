//
//  LocationManager.swift
//  Uber
//
//  Created by Fady Sameh on 7/8/24.
//

import Foundation
import CoreLocation

//class LocationManager: NSObject, CLLocationManagerDelegate {
//    static let shared = LocationManager()
//    
//    let manager = CLLocationManager()
//    
//    var completion: ((CLLocation) -> Void)?
//    
//    public func resolveLocationName(with location: CLLocation, completion: @escaping ((String?) -> Void)) {
//        let geocoder = CLGeocoder()
//        geocoder.reverseGeocodeLocation(location, preferredLocale: .current) { placemarks, error in
//            guard let place = placemarks?.first, error == nil else {
//                completion(nil)
//                return
//            }
//            print(place)
//            
//            var name = ""
//            
//            if let locality = place.locality {
//                name += locality
//            }
//            
//            if let adminRegion = place.administrativeArea {
//                name += ", \(adminRegion)"
//            }
//            
//            completion(name)
//            
//        }
//    }
//    
//    public func getUserCurrentLocation(completion: @escaping ((CLLocation) -> Void)) {
//        self.completion = completion
//        manager.requestWhenInUseAuthorization()
//        manager.delegate = self
//        
//        //
//        manager.desiredAccuracy = kCLLocationAccuracyBest // accuracy best is not better for battery
//        manager.allowsBackgroundLocationUpdates = true
//        //
//        
//        manager.startUpdatingLocation()
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.first else { return }
//        completion?(location)
//        manager.stopUpdatingLocation()
//    }
//    
//}
//
//// MARK: - peremssion
//extension LocationManager {
//    func isLocationServiceEnabled() -> Bool{
//        return CLLocationManager.locationServicesEnabled()
//    }
//    func checkAuthorization(){
//        switch manager.authorizationStatus {
//        case .notDetermined:
//            manager.requestAlwaysAuthorization()
//            break
//        case .authorizedWhenInUse:
//            manager.startUpdatingLocation()
//            //            mabView.showsUserLocation = true
//            break
//        case .authorizedAlways:
//            manager.startUpdatingLocation()
//            //            mabView.showsUserLocation = true
//            break
//            
//        case .denied:
//            print("Please authorize access to location")
//            break
//        case .restricted:
//            print("Authorization restricted")
//            break
//        default:
//            print ("default state of map")
//        }
//    }
//}

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
//    let manager = CLLocationManager()
    
    public func findLocations(with query: String, completion: @escaping (([Location]) -> Void)) {
        
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(query) { places, error in
            guard let places = places, error == nil else {
                completion([])
                return
            }
            
            let models: [Location] = places.compactMap({ place in
                var name = ""
                
                if let locationName = place.name {
                    name += locationName
                }
                
                if let adminRegion = place.administrativeArea {
                    name += ", \(adminRegion)"
                }
                
                if let locality = place.locality {
                    name += ", \(locality)"
                }
                
                if let country = place.country {
                    name += ", \(country)"
                }
                
                print("\n\(place)\n\n")
                
                let result = Location(
                    title: name,
                    coordinates: place.location?.coordinate
                )
                return result
            })
            
            completion(models)
        }
    }
    
    
}

struct Location {
    let title: String
    let coordinates: CLLocationCoordinate2D?
}
