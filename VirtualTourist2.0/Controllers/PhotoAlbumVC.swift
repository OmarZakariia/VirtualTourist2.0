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
    
    
    
    // MARK: - IBOutlets and Properties
    @IBOutlet weak var mapFragment : MKMapView!
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var newCollectionButton : UIButton!
    var dataControllerClass : DataControllerClass!
    
    let regionRadius : CLLocationDistance = 1000
    
    let photoCell = PhotoCell()
    
    var flickerPhotos : [FlickrImage] = [FlickrImage]()
    
    var coreDataPhotos : [Photo] = []
    
    var pin : Pin! = nil
    
    var coordinateSelected : CLLocationCoordinate2D!
    
    
    var selectedToDelete : [Int] = [] {
        didSet{
            if selectedToDelete.count > 0 {
                newCollectionButton.setTitle("Remove the pictures selected", for: .normal)
            } else {
                newCollectionButton.setTitle("New Collection ", for: .normal)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        performUpdatesForUIOnTheMainQueue{
           self.collectionView.reloadData()
            print("📷\(self.coreDataPhotos.count)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        newCollectionButton.isHidden = false
        
        addAnnotationToMap()
        
        layoutForCollectionView()
        
        fetchRequestForPhotos()
        
    }
    
    
    // MARK: - Functions
    
    func fetchRequestForPhotos(){
        let fetchRequest : NSFetchRequest<Photo> =  Photo.fetchRequest()
        
        let predicate = NSPredicate(format: "pin == %@", pin)
        
        fetchRequest.predicate = predicate
        
        if let result = try? dataControllerClass.viewContext.fetch(fetchRequest){
            coreDataPhotos = result
//            print("result \(result)")
            try? dataControllerClass.viewContext.save()
            
            performUpdatesForUIOnTheMainQueue {
                if self.coreDataPhotos.count == 0 {
                    self.flickerPhotosRequestFromPin()
                }
            }
            self.collectionView.reloadData()
        }
        print("fetchRequestForPhotos called" )
    }
    
    func flickerPhotosRequestFromPin() {
        print("flickerPhotosRequestFromPin called")
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
                print("\(error)from flickerPhotosRequestFromPin" ?? "empty error from flickerPhotosRequestFromPin")
            }
        }
    }
    
    
   
    
    func selectedToDeleteFromIndexPath(_ indexPathArray : [IndexPath])-> [Int]{
        var selected: [Int] = []
        
        for indexPath in indexPathArray{
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
        print("newCollectionPhotos pressed")
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
    
    func addAnnotationToMap(){
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinateSelected
        mapFragment.addAnnotation(annotation)
        mapFragment.showAnnotations([annotation], animated: true)
    }
   
}


// MARK: - PhotoAlbumVC Extension
extension PhotoAlbumVC{
    
    func layoutForCollectionView(){
        let width = (view.frame.size.width - 20) / 3
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize =  CGSize(width: width, height: width)
        
        collectionView.isHidden = false
        collectionView.allowsMultipleSelection = true
    }
}
