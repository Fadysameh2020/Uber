//
//  HomeViewController.swift
//  Uber
//
//  Created by Fady Sameh on 7/8/24.
//

import UIKit
import MapKit
import FloatingPanel
import CoreLocation

class HomeViewController: UIViewController {
    
    let mapView = MKMapView()

    let panel = FloatingPanelController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(mapView)
        title = "Uber"
        
        let viewController = Uber.SearchViewController()
        viewController.delegate = self
        panel.set(contentViewController: viewController)
        panel.addPanel(toParent: self, animated: true)
        panel.surfaceView.makeCorner(withRadius: 16)
//        panel.surfaceView.backgroundColor = .clear
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        mapView.frame = view.bounds
    }

}

extension HomeViewController: SearchViewControllerDelegate {
    func SearchViewController(_ vc: SearchViewController, didSelectLocationWith coordinates: CLLocationCoordinate2D?) {
        
        guard let coordinates = coordinates else { return }
        
        panel.dismiss(animated: true, completion: nil)
        
        mapView.removeAnnotations(mapView.annotations)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        mapView.addAnnotation(pin)
        
        mapView.setRegion(
            MKCoordinateRegion(
                center: coordinates,
                span: MKCoordinateSpan(
                    latitudeDelta: 0.7,
                    longitudeDelta: 0.7
                )
            ),
            animated: true
        )
    }
    
    
}
