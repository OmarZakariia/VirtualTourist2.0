//
//  TravelMapViewController.swift
//  VirtualTourist2.0
//
//  Created by Zakaria on 11/11/2021.
//

import UIKit
import CoreData
import MapKit

class TravelMapViewController: UIViewController, UIGestureRecognizerDelegate {
    
    
    // MARK: - IBOutlets and Properties
    
    var dataControllerClass : DataControllerClass!
    
    @IBOutlet weak var editButton : UIBarButtonItem!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var deletePinsMessage : UIView!
    
    var editMode: Bool = false
    
    var pins : [Pin] = []
    
    var pinsOnMap : [PinOnMap] = []
    
    var pinToBePassed : Pin? = nil
    
    var pinCoordinate : CLLocationCoordinate2D? = nil
    
    var flickerPhotos : [FlickrImage] = [FlickrImage]()
    
    
    // gesture recognizer
    var longTapGesture: UILongPressGestureRecognizer!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setEditDoneButton()
        
        fetchRequestForPin()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupLongTapGesture()
    }
    
    
    // MARK: - Functions
    
    func setupLongTapGesture() {
        print("setupLongTapGesture -- long tap gesture has been detected")
        longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTapGestureHandler(_:)))
        longTapGesture.minimumPressDuration = 0.2
        longTapGesture.delegate = self
        mapView.addGestureRecognizer(longTapGesture)
    }
    
    // LongTapGestureRecognizer
    
    @objc func longTapGestureHandler(_ gestureRecognizer: UIGestureRecognizer) {
        
        // get the location touched on the map
        let touchedAt = gestureRecognizer.location(in: self.mapView)
        
        // get the coordinates touched on the map
        let coordinateTouched : CLLocationCoordinate2D = mapView.convert(touchedAt, toCoordinateFrom: self.mapView)
        
        // create a new pin
        let newPin = MKPointAnnotation()
        
        // add coordinatestouched to the newPin
        newPin.coordinate = coordinateTouched
        
        // add the newPin to the map
        mapView.addAnnotation(newPin)
        
        // after adding pin to map, send the data to PhotoAlbumVC and present it
        
        let photoAlbumVC =  PhotoAlbumVC()
        
        photoAlbumVC.coordinateSelected =  coordinateTouched
        
        photoAlbumVC.dataControllerClass = dataControllerClass
        
        photoAlbumVC.flickerPhotos = flickerPhotos
        
      
        photoAlbumVC.modalPresentationStyle = .fullScreen
        
        present(photoAlbumVC, animated: true, completion: nil)
        
        
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
    
}
    
