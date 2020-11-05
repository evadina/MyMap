//
//  ViewController.swift
//  MyMap
//
//  Created by Madina Tazhiyeva on 11/1/20.
//  Copyright © 2020 Madina Tazhiyeva. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func onClickShowLocations(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let popup = storyboard.instantiateViewController(withIdentifier: "LocationsList") as! LocationsTableViewController
        self.present(popup, animated: true, completion: nil)
    }
    
    //    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    //    {
    //        if let annotationTitle = view.annotation?.title
    //        {
    //            print("User tapped on annotation with title: \(annotationTitle!)")
    //        }
    //    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       loadFromCoreData()

        
        mapView.delegate = self
        
        let initialLocation = CLLocation(latitude: 43.238949, longitude: 76.889709)
        mapView.centerToLocation(initialLocation)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        longPressRecognizer.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(longPressRecognizer)
        
    }
    
    @objc func handleTap(_ gestureRecognizer: UILongPressGestureRecognizer){
        
        let location = gestureRecognizer.location(in: mapView)
        let coordinates = mapView.convert(location, toCoordinateFrom: mapView)
        showAlert(title: "Введите название", longitude: coordinates.longitude, latitude: coordinates.latitude)
    }
    
    func showAlert(title: String, longitude: Double, latitude: Double){
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default){
            (UIAlertAction) in
            
            let locationName = alert.textFields?[0].text ?? " "
            let locationDescription = alert.textFields?[1].text ?? " "
            self.saveLocation(withName: locationName, withDescription: locationDescription, withLongitude: longitude, withLatitide: latitude)
            print("showAlert \(Data.locations.count)")
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Location name"
        })
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Location description"
        })
        
        self.present(alert, animated: true)
        
    }
    
    func addAnnotation(_ name: String, _ description: String, _ latitude: Double, _ longitude: Double){
           let annotation = MKPointAnnotation()
           annotation.coordinate.latitude = latitude
           annotation.coordinate.longitude = longitude
           annotation.title = name
           annotation.subtitle = description
           mapView.addAnnotation(annotation)
       }
    
    func deleteAllAnnotations(){
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
    }
    
    func saveLocation(withName name: String, withDescription description: String, withLongitude longitude: Double, withLatitide latitude: Double){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Locations", in: context) else { return }
        let locationObj = Locations(entity: entity, insertInto: context)
        locationObj.locationName = name
        locationObj.locationDescription = description
        locationObj.longitude = longitude
        locationObj.latitude = latitude
        
        do{
            try context.save()
            Data.locations.append(locationObj)
            addAnnotation(name, description, latitude, longitude)
            print("savelocation \(Data.locations.count)")
            
        } catch let error as NSError{
            print(error.localizedDescription)
        }
    }
    
    func loadFromCoreData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<Locations> = Locations.fetchRequest()

        do{
            Data.locations = try context.fetch(fetchRequest)

        } catch let error as NSError{
            print(error.localizedDescription)
        }
        
        
        
        for item in Data.locations{
            let annotation = MKPointAnnotation()
            annotation.coordinate.latitude = item.latitude
            annotation.coordinate.longitude = item.longitude
            annotation.title = item.locationName
            annotation.subtitle = item.locationDescription
            mapView.addAnnotation(annotation)
        }
    }
    
    
}

private extension MKMapView {
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 10000
    ) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}

