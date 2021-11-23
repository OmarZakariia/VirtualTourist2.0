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
    // Class to represent map for the user to be able to mark locations using a pin
    
    // MARK: - IBOutlets
    
    // core data
    var dataControllerClass : DataControllerClass!
    
    
    @IBOutlet weak var editButton : UIBarButtonItem!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var deletePinsMessage : UIView!
    
    
    
    // MARK: - Properties
    
    
    
    var editMode: Bool = false
    
    // array of persistent data 'Pin'
    var pins : [Pin] = []
    
    // pins that become annotiations on the map
    var pinsOnMap : [PinOnMap] = []
    
    // pin that will be passed to the PhotoAlbumVC
    var pinToBePassed : Pin? = nil
    
    // coordinate of the pin
    var pinCoordinate : CLLocationCoordinate2D? = nil
    
    // array of flickrImage that are downloaded
    var flickerPhotos : [FlickrImage] = [FlickrImage]()
    
    // CLLocationManager
    let locationManager  = CLLocationManager()
    
    //
    var touchedCoordinate : CLLocationCoordinate2D!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cLLocationManagerSetup()
        
        setEditDoneButton()
        
//        fetchRequestForPin()
    }
    
    
    
    
    // MARK: - Functions
    
    
    func fetchRequestForPin(){
        
        let fetchRequest : NSFetchRequest<Pin> = Pin.fetchRequest()
        
        if let result = try? dataControllerClass.viewContext.fetch(fetchRequest) {
            // check for search resutls, if there are any, assign them to the persisted pin array
            pins = result
        }
        
        for pin in pins {
            // loop through the pins, assign coordinates to it, append it to the array and finally add it to the mapView
            let coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
            
            let pins = PinOnMap(coordinate: coordinate)
            
            pinsOnMap.append(pins)
            
        }
        mapView.addAnnotations(pinsOnMap)
    }
    
    func setEditDoneButton(){
        // place the edit button on the navigation bar
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        // is the viewController editable or not ?
        super.setEditing(editing, animated: animated)
        
        // delete pins messafe is hidden then editing is set to false
        deletePinsMessage.isHidden = !editing
        
        // if edit mode is on the editing is true
        editMode = editing
        
        
    }
    
    
    func addPinToCoreData(coordinate : CLLocationCoordinate2D){
        
        let pin = Pin(latitude: coordinate.latitude, longitude: coordinate.longitude, context: dataControllerClass.viewContext)
        
        pins.append(pin)
        
        try? dataControllerClass.viewContext.save()
    }
    
    
    
    
//    func requestFlickrPhotosFromPin(coordinate : CLLocationCoordinate2D) {
//
//        ClientForFlickr.sharedInstance().getPhotosPath(lat: coordinate.latitude, lon: coordinate.longitude) { photos, error in
//            if let photos = photos {
//                self.flickerPhotos = photos
//            } else {
//                print(error ?? "empty error")
//            }
//
//        }
//        print("\(flickerPhotos)")
//    }
    
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
        
        longPress.minimumPressDuration = 0.3
        mapView.addGestureRecognizer(longPress)
        
    }
    
    
    
    func launchViewController (_ recognizer: UIGestureRecognizer) {
        // if the view is not edit mode, add pins and move to photoAlbumVC
        guard editMode == false else {return}
            print("A long press has been deteced")
            
            // get the place where user tapped
            let touchedAt =  recognizer.location(in: self.mapView)
            
            // convert the place where the user touched in the map to a coordinate
             touchedCoordinate  = mapView.convert(touchedAt, toCoordinateFrom: self.mapView)
            
            // create a new pin
            let newPin = MKPointAnnotation()
            
            // add the coordinate to the new pin
            newPin.coordinate =  touchedCoordinate
            
            // add the new pin to the map
            mapView.addAnnotation(newPin)
            
            // after adding the new pin, delay for 0.2 seconds to load the PhotoAlbumVC and pass the required data
    }
    
    

    
    @objc  func mapLongPress(_ recognizer : UIGestureRecognizer){
        switch recognizer.state  {
        case .began:
            self.becomeFirstResponder()
            launchViewController(recognizer)
        case.ended:
                // instantiate a new PhotoAlbumVC and pass the required data
            let photoAlbumViewController = self.storyboard?.instantiateViewController(withIdentifier: "PhotoAlbumVC") as! PhotoAlbumVC
                  
                photoAlbumViewController.dataControllerClass = dataControllerClass
                
                // should send the newPin to the photoAlbumVC
                photoAlbumViewController.pin = pinToBePassed
                
                photoAlbumViewController.coordinateSelected =  touchedCoordinate
                 
                self.navigationController?.pushViewController(photoAlbumViewController, animated: false)
        default:
            print("hamada")
        }
        
        
    }
    
    
    
    // MARK: - IBActions Functions
    
    
    
    
    
    
}





