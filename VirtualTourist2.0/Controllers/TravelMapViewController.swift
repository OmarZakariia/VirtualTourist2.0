//
//  TravelMapViewController.swift
//  VirtualTourist2.0
//
//  Created by Zakaria on 11/11/2021.
//

import UIKit
import CoreData
import MapKit

class TravelMapViewController: UIViewController, CLLocationManagerDelegate {
    
    
    // MARK: - IBOutlets
    
    var dataControllerClass : DataControllerClass!
    
    @IBOutlet weak var editButton : UIBarButtonItem!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var deletePinsMessage : UIView!
    
    
    
    // MARK: - Properties
    var editMode: Bool = false
    
    var pins : [Pin] = []
    
    var pinsOnMap : [PinOnMap] = []
    
    var pinToBePassed : Pin? = nil
    
    var pinCoordinate : CLLocationCoordinate2D? = nil
    
    var flickerPhotos : [FlickrImage] = [FlickrImage]()
    
    // CLLocationManager
    let locationManager  = CLLocationManager()
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cLLocationManagerSetup()

        setEditDoneButton()
        
        fetchRequestForPin()
    }
    
    
    
    
    // MARK: - Functions
    
    fileprivate func cLLocationManagerSetup() {
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if #available(iOS 8.0, *){
            locationManager.requestAlwaysAuthorization()
        } else {
             
//             fallback to earlier versions
        }
        locationManager.startUpdatingLocation()
        
        let longPress  = UILongPressGestureRecognizer(target: self, action: #selector(self.mapLongPress(_:)))
        
        longPress.minimumPressDuration = 1.5
        mapView.addGestureRecognizer(longPress)
        
    }
    
   @objc  func mapLongPress(_ recognizer : UIGestureRecognizer){
        print("A long press has been detected")
        
        let touchedAt = recognizer.location(in: self.mapView)
        
        let touchedCoordinate : CLLocationCoordinate2D = mapView.convert(touchedAt, toCoordinateFrom: self.mapView)
        
        let newPin = MKPointAnnotation()
        newPin.coordinate = touchedCoordinate
        mapView.addAnnotation(newPin)
       
       performSegue(withIdentifier: "PinPhotos", sender: self)
    }
    
    func fetchRequestForPin(){
        let fetchRequest : NSFetchRequest<Pin> = Pin.fetchRequest()
        if let result = try? dataControllerClass.viewContext.fetch(fetchRequest) {
            pins = result
        }
        
        for pin in pins {
            let coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
            let pins = PinOnMap(coordinate: coordinate)
            pinsOnMap.append(pins)
        }
        mapView.addAnnotations(pinsOnMap)
    }

    func setEditDoneButton(){
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        deletePinsMessage.isHidden = !editing
        editMode = editing
        
        
    }
    
    
    func addPinToCoreData(coordinate : CLLocationCoordinate2D){
        let pin = Pin(latitude: coordinate.latitude, longitude: coordinate.longitude, context: dataControllerClass.viewContext)
        pins.append(pin)
        
        try? dataControllerClass.viewContext.save()
    }
    
    
    

    func requestFlickrPhotosFromPin(coordinate : CLLocationCoordinate2D){
        ClientForFlickr.sharedInstance().getPhotosPath(lat: coordinate.latitude, lon: coordinate.longitude) { photos, error in
            if let photos = photos {
                self.flickerPhotos = photos
            } else {
                print(error ?? "empty error")
            }
           
        }
        print("\(flickerPhotos)")
    }
    
    // MARK: - IBActions Functions
    
    @IBAction func addPinToMap(_ sender: UITapGestureRecognizer){
        if !editMode {
            let gestureTouchLocation : CGPoint = sender.location(in: mapView)
            
            let coordinateToAdd : CLLocationCoordinate2D = mapView.convert(gestureTouchLocation, toCoordinateFrom: mapView)
            
            let annotation : MKPointAnnotation = MKPointAnnotation()
            
            annotation.coordinate = coordinateToAdd
            
            mapView.addAnnotation(annotation)
            
            addPinToCoreData(coordinate: coordinateToAdd)
            
            requestFlickrPhotosFromPin(coordinate: coordinateToAdd)
                
            print("addPinToMap pressed")
            
        }
        
    }
    
}


// MARK: - Extension

extension TravelMapViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PinPhotos" {
            let photoAlbumVC = segue.destination as! PhotoAlbumVC
            
            let coordinate = sender as! CLLocationCoordinate2D
            
            
            photoAlbumVC.dataControllerClass = dataControllerClass
            
            photoAlbumVC.pin = pinToBePassed
            
            photoAlbumVC.coordinateSelected = coordinate
            
            photoAlbumVC.flickerPhotos = flickerPhotos
            
        }
    }
}




