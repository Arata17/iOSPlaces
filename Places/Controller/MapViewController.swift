//
//  ViewController.swift
//  Places
//
//  Created by Мирас on 11/1/20.
//

import UIKit
import MapKit
import CoreData



class MapViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var annotationsList = [Annotation]()
    var selectedAnnotation: Annotation?
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    override func viewWillAppear(_ animated: Bool) {
        
        loadPins()
        mapView.removeAnnotations(annotationsList)
        mapView.addAnnotations(annotationsList)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action:#selector(longTap))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
        
        mapView.delegate = self
        

    }
    
   
    
    
    
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = MKMapType.standard
        case 1:
            mapView.mapType = MKMapType.satellite
        case 2:
            mapView.mapType = MKMapType.hybrid
        default:
            mapView.mapType = MKMapType.standard
        }
    }
    
    func createAnnotation(coordinate: CLLocationCoordinate2D){
        
        var titleField = UITextField()
        var subTitleField = UITextField()
        
        
        let alert = UIAlertController(title: "Add New Place", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newAnnotation = Annotation(context: self.context)
            newAnnotation.title = titleField.text
            newAnnotation.subtitle = subTitleField.text
            newAnnotation.lat = coordinate.latitude
            newAnnotation.lon = coordinate.longitude
            self.annotationsList.append(newAnnotation)
            self.savePins()
            self.mapView.addAnnotation(newAnnotation)
            print(self.annotationsList.count)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Title"
            titleField = alertTextField
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Subtitle"
            subTitleField = alertTextField
        }
        alert.addAction(action)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func savePins(){ 
        do{
            try self.context.save()
        } catch{
            print(error)
        }
    }
    
    
    func loadPins(){ //load data
        let request: NSFetchRequest<Annotation> = Annotation.fetchRequest()
        do{
            annotationsList = try context.fetch(request)
        }catch{
            print(error)
        }
        
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "wayPointsSegue"{
            if let destVC = segue.destination as? WayPointsVC{
                destVC.delegate = self
            }
        } else {
            if let destVC = segue.destination as? EditWayPointVC{
                destVC.titleText = selectedAnnotation?.title
                destVC.subTitle = selectedAnnotation?.subtitle
                
                destVC.delegate = self
            }
        }
    }
    
    @objc func editWayPoint(){
        
        performSegue(withIdentifier: "editVCSegue", sender: self)
    }
}

//MARK: - Tap Gesture Delegate
extension MapViewController: UIGestureRecognizerDelegate {
    @objc func longTap(gestureRecognizer: UILongPressGestureRecognizer) {
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        if gestureRecognizer.state == .ended{
            createAnnotation(coordinate: coordinate)
            
        }
    }
}

//MARK: - Map View Delegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKUserLocation) {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: String(annotation.hash))
            
            let rightButton = UIButton(type: .infoLight)
            rightButton.tag = annotation.hash
            rightButton.addTarget(self, action: #selector(editWayPoint), for: .touchUpInside)
            
            
            pinView.animatesDrop = true
            pinView.canShowCallout = true
            pinView.rightCalloutAccessoryView = rightButton
            
            return pinView
        }
        else {
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.selectedAnnotation = view.annotation as? Annotation
    }
}

extension MapViewController: PinZoomProtocol{
    func setCenter(latitude lat: Double, longitude lon: Double, name: String) {
        navigationItem.title = name
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 30000, longitudinalMeters: 30000)
        mapView.setRegion(region, animated: true)
    }
}

extension MapViewController: EditAnnotationInfoProtocol{
    func editAnnotation(title: String, subTitle: String) {
        let index = annotationsList.firstIndex(of: selectedAnnotation!)
        let annotationEdit = annotationsList[index!]
        
        annotationEdit.title = title
        annotationEdit.subtitle = subTitle
        
       
        savePins()
    }
}

