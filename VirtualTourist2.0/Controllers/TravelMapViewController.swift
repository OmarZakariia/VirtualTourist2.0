//
//  TravelMapViewController.swift
//  VirtualTourist2.0
//
//  Created by Zakaria on 11/11/2021.
//

import UIKit
import CoreData
import MapKit

class TravelMapViewController: UIViewController {
    
    
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
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setEditDoneButton()
        
        fetchRequestForPin()
    }
    
    
    
    
    // MARK: - Functions
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

