//
//  LocationViewController.swift
//  Chat
//
//  Created by Om Gandhi on 27/03/24.
//

import UIKit
import MapKit
import CoreLocation
class LocationViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    public var coordinates = CLLocation()
    override func viewDidLoad() {
        super.viewDidLoad()

        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: coordinates.coordinate.latitude, longitude: coordinates.coordinate.longitude), latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: coordinates.coordinate.latitude, longitude: coordinates.coordinate.longitude)
        mapView.addAnnotation(pin)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
