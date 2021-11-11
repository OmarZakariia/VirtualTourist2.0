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
            print("\(self.coreDataPhotos.count)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        newCollectionButton.isHidden = false
        
        addAnnotationToMap()
        
        collectionViewLayout()
        
        fetchRequestForPhotos()
        
    }
    
    
    // MARK: - Functions
    
    func fetchRequestForPhotos(){
        let fetchRequest : NSFetchRequest<Photo> =  Photo.fetchRequest()
        
        let predicate = NSPredicate(format: "pin == %@", pin)
        
        fetchRequest.predicate = predicate
        
        if let result = try? dataControllerClass.viewContext.fetch(fetchRequest){
            coreDataPhotos = result
            try? dataControllerClass.viewContext.save()
            
            performUpdatesForUIOnTheMainQueue {
                if self.coreDataPhotos.count == 0 {
                    
                }
            }
        }
    }
    /*
     func fetchRequestForPhotos() {
         
         // hay objetos 'Photo' persistidos? 🔍
         let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
         
         // predicate: filtrar ÚNICAMENTE las fotos asociadas al 'pin' actual 👈
         let predicate = NSPredicate(format: "pin == %@", pin)
         
         // pone a la solicitud de búsqueda este predicado específico
         fetchRequest.predicate = predicate
         
         // el resultado de la búsqueda
         if let result = try? dataController.viewContext.fetch(fetchRequest) {
             
                     // si el resultado de la solicitud es exitoso
                     // lo guarda en el array de fotos
                     coreDataPhotos = result // coreDataPhotos: [Photo] 🔌
             
 //                    // intenta guardar el contexto (para que los datos, las fotos asociadas, queden persistidas)
 //                    try? dataController.viewContext.save() // 💿
             
                     // y actualiza la interfaz con los datos...
             
                     // dispatch
                     performUIUpdatesOnMain {
                         
                         // comprueba el resultado de la solicitud
                         // si el array 'coreDataPhotos' está vacío..
                         if self.coreDataPhotos.count == 0 {
                             
                             // ..entonces hacer una solicitud web para obtener un set de fotos
                             // Flickr Client 👈 ///////////////////////////////////////////////////////////////////////////////////////
                             
                             /// task: obtener un nuevo set de fotos asociadas a un pin determinado y guardarlas
                             self.requestFlickrPhotosFromPin()

                         } // end if
                         
                         // si hay fotos persistidas actualizar con ellas el 'collection view'
                         self.collectionView.reloadData() // ACTUALIZA EL MODELO
             }
         }
     }
     */

   
}
