//
//  MapViewController.swift
//  medApp
//
//  Created by Somya Bansal on 26/11/23.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var backButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self

        // Add annotations for prominent medical stores (using hard-coded coordinates)
        addMedicalStoreAnnotation(title: "Medical Store 1", latitude: 28.6139, longitude: 77.2090)
        addMedicalStoreAnnotation(title: "Medical Store 2", latitude: 19.0760, longitude: 72.8777)
        addMedicalStoreAnnotation(title: "Medical Store 3", latitude: 12.9716, longitude: 77.5946)
        addMedicalStoreAnnotation(title: "Medical Store 4", latitude: 17.3850, longitude: 78.4867)
        addMedicalStoreAnnotation(title: "Medical Store 5", latitude: 22.5726, longitude: 88.3639)
        addMedicalStoreAnnotation(title: "Medical Store 6", latitude: 28.6139, longitude: 77.2090)
        addMedicalStoreAnnotation(title: "Medical Store 7", latitude: 13.0827, longitude: 80.2707)
        addMedicalStoreAnnotation(title: "Medical Store 8", latitude: 25.2769, longitude: 83.0302)


        // Set initial region and zoom level
        let initialLocation = CLLocationCoordinate2D(latitude: 20.5937, longitude: 78.9629)
        let regionRadius: CLLocationDistance = 1000000 // Set the desired zoom level
        let region = MKCoordinateRegion(center: initialLocation, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func backAction(_ sender: Any) {
        performSegue(withIdentifier: "connect", sender: nil)
    }
    

    // Function to add a medical store annotation to the map
    func addMedicalStoreAnnotation(title: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = title
        mapView.addAnnotation(annotation)
    }

    // MKMapViewDelegate method to customize the appearance of the annotations
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "marker"
        var view: MKMarkerAnnotationView

        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }

        return view
    }

    // MKMapViewDelegate method to handle accessory button taps
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            // Handle the tap on the accessory button (e.g., open details for the medical store)
            print("Accessory button tapped for \(view.annotation?.title ?? "")")
        }
    }
}
