//
//  PhotoAlbumVC+CollectionViewMethods.swift
//  VirtualTourist2.0
//
//  Created by Zakaria on 13/11/2021.
//

import UIKit
import MapKit



// MARK: - UICollectionViewDataSource

extension PhotoAlbumVC: UICollectionViewDataSource{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return coreDataPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let photo = coreDataPhotos[(indexPath as NSIndexPath).row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        
        
        if photo.imageData != nil{
            
            let photo = UIImage(data: photo.imageData! as Data)
            
            performUpdatesForUIOnTheMainQueue {
                
                cell.photoImageView.image = photo
                
                cell.activityIndicator.stopAnimating()
                
            }
        } else {
            
            if let photoPath = photo.imageURL {
                
                let _ = ClientForFlickr.sharedInstance().taskForGetImage(photoPath: photoPath) { imageData, error in
                    
                    if let image = UIImage(data: imageData!){
                        
                        photo.imageData = NSData.init(data: imageData!)
                        
                        try? self.dataControllerClass.viewContext.save()
                        
                        performUpdatesForUIOnTheMainQueue {
                            
                            cell.photoImageView.image = image
                            
                            cell.activityIndicator.stopAnimating()
                            
                        }
                    } else {
                        print(error ?? "empty error from cellForItemAt collectionView ")
                    }
                }
            }
        }
        
        
        return cell
    }
    
    
}


// MARK: - UICollectionViewDelegate


extension PhotoAlbumVC: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedToDelete = selectedToDeleteFromIndexPath(collectionView.indexPathsForSelectedItems!)
        
        let cell = collectionView.cellForItem(at: indexPath)
        
        DispatchQueue.main.async {
            cell?.contentView.alpha = 0.4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        selectedToDelete = selectedToDeleteFromIndexPath(collectionView.indexPathsForSelectedItems!)
        
        let cell = collectionView.cellForItem(at: indexPath)
        
        DispatchQueue.main.async {
            cell?.contentView.alpha = 1.0
        }
    }

}
