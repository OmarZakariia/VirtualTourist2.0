//
//  PhotoAlbumVC.swift
//  VirtualTourist2.0
//
//  Created by Zakaria on 11/11/2021.
//

import UIKit
import MapKit
import CoreData


class PhotoAlbumVC: UIViewController {
    
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var mapFragment : MKMapView! {
        didSet {
            self.addAnnotationToMap()
        }
    }
    @IBOutlet weak var collectionView : UICollectionView! {
        didSet {
            self.layoutForCollectionView()
            self.fetchRequestForPhotos()
        }
    }
    @IBOutlet weak var newCollectionButton : UIButton!
    
    
    
    
    // MARK: -  Properties
    var dataControllerClass : DataControllerClass!
    
    let regionRadius : CLLocationDistance = 1000
    
    let photoCell = PhotoCell()
    
    var flickerPhotos : [FlickrImage] = [FlickrImage]()
    
    var coreDataPhotos : [Photo] = []
    
    var pin : Pin! = nil
    
    var coordinateSelected : CLLocationCoordinate2D!
    
    
    
    
    
    var selectedToDelete : [Int] = [] {
        didSet {
            if selectedToDelete.count > 0 {
                newCollectionButton.setTitle("Remove the pictures selected", for: .normal)
            } else {
                newCollectionButton.setTitle("New Collection ", for: .normal)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        performUpdatesForUIOnTheMainQueue{
//
//            print("📷\(self.coreDataPhotos.count)")
//        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded Hamada")
    }
    
    
    // MARK: - Functions
    
    
    
    func fetchRequestForPhotos(){
        let fetchRequest : NSFetchRequest<Photo> =  Photo.fetchRequest()
        
        let predicate = NSPredicate(format: "pin == %@", pin)
  
        
        fetchRequest.predicate = predicate
        
        if let result = try? dataControllerClass.viewContext.fetch(fetchRequest){
            coreDataPhotos = result
//            print("result \(result)")
//            try? dataControllerClass.viewContext.save()
            
            performUpdatesForUIOnTheMainQueue {
                if self.coreDataPhotos.count == 0 {
                    self.flickerPhotosRequestFromPin()
                }
                self.collectionView.reloadData()
            }
            
        }
        
    }
    
    func flickerPhotosRequestFromPin() {
        
        ClientForFlickr.sharedInstance().getPhotosPath(lat: coordinateSelected.latitude, lon: coordinateSelected.longitude) { photos, error in
            if let photos = photos {
                
                self.flickerPhotos = photos
                
                for photo in self.flickerPhotos {
                    
                    let photoPath = photo.photoPath
                    
                    let photoCoreData = Photo(imageURL: photoPath, context: self.dataControllerClass.viewContext)
                    
                    photoCoreData.pin = self.pin
                    
                    self.coreDataPhotos.append(photoCoreData)
                    
                    try? self.dataControllerClass.viewContext.save()
                    
                }
                performUpdatesForUIOnTheMainQueue {
                    
                    self.collectionView.reloadData()
                    
                }
            } else {
                
               // print("\(error)from flickerPhotosRequestFromPin" ?? "empty error from flickerPhotosRequestFromPin")
                print(error ?? "empty error from flickerPhotosRequestFromPin ")
            }
        }
    }
    
    
   
    
    func selectedToDeleteFromIndexPath(_ indexPathArray : [IndexPath])-> [Int]{
        var selected: [Int] = []
        
        for indexPath in indexPathArray {
            
            selected.append(indexPath.item)
            
        }
        return selected
    }
   
    // MARK: - IBAction Functions
    @IBAction func deleteSelected(_ sender: Any){
        
        
        if let selected: [IndexPath] = collectionView.indexPathsForSelectedItems {
            let items = selected.map{$0.item}.sorted().reversed()
            
            for item in items {
                dataControllerClass.viewContext.delete(coreDataPhotos.remove(at: item))
                try? dataControllerClass.viewContext.save()
            }
            collectionView.deleteItems(at: selected)
        }
    }
    
    @IBAction func newCollectionPhotos(_ sender: UIButton){
        
        if selectedToDelete.count > 0 {
            print("There is more than one selected item to delete")
        } else {
            flickerPhotosRequestFromPin()
        }
    }
    
       
    // MARK: - MapView Functions

     
    func centerMapOnLocation(location : CLLocation){
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapFragment.setRegion(coordinateRegion, animated: true)
    }
    
    
    // Add the pin to the map
    func addAnnotationToMap(){
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinateSelected
        mapFragment.addAnnotation(annotation)
        mapFragment.showAnnotations([annotation], animated: true)
    }
   
}


// MARK: - PhotoAlbumVC Extension
extension PhotoAlbumVC{
    
    
    
    // Custom layout for the collectionView
    func layoutForCollectionView(){
        let width = (view.frame.size.width - 20) / 3
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize =  CGSize(width: width, height: width)
        
        collectionView.isHidden = false
        collectionView.allowsMultipleSelection = true
    }
}




