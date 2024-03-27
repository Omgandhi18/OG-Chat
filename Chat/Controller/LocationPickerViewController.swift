//
//  LocationPickerViewController.swift
//  Chat
//
//  Created by Om Gandhi on 27/03/24.
//

import UIKit
import MapKit
import CoreLocation
class LocationPickerViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    public var completion: ((CLLocationCoordinate2D) -> Void)?
    public var location: CLLocationCoordinate2D?
    public var userLocation = CLLocationCoordinate2D()
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pick Location"
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                self.locationManager.startUpdatingLocation()
               
            }
        }
        mapView.isUserInteractionEnabled = true
        mapView.showsUserLocation = true
       
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send", style: .done, target: self, action: #selector(sendButtonTapped))
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapMap(_:)))
        gesture.numberOfTouchesRequired = 1
        gesture.numberOfTapsRequired = 1
        mapView.addGestureRecognizer(gesture)
    }
    @objc func sendButtonTapped(){
        guard let location = location else{
            return
        }
        navigationController?.popViewController(animated: true)
        completion?(location)
    }
    @objc func didTapMap(_ gesture: UITapGestureRecognizer){
        let locationInView = gesture.location(in: mapView)
        let coordinates = mapView.convert(locationInView, toCoordinateFrom: mapView)
        location = coordinates
        //drop pin
        for annotation in mapView.annotations{
            mapView.removeAnnotation(annotation)
        }
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        
        mapView.addAnnotation(pin)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.mapView.setRegion(MKCoordinateRegion(center: locValue, latitudinalMeters: 200, longitudinalMeters: 200), animated: false)
        locationManager.stopUpdatingLocation()
    }

}
