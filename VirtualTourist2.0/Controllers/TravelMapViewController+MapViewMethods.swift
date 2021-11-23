//
//  TravelMapViewController+MapViewMethods.swift
//  VirtualTourist2.0
//
//  Created by Zakaria on 13/11/2021.
//

import UIKit
import CoreData
import MapKit


extension TravelMapViewController : MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let coordinateSelected = view.annotation?.coordinate
        let latitude = coordinateSelected?.latitude
        let longitude = coordinateSelected?.longitude
        
        if !editMode{
            for pin in pins{
                if pin.latitude == latitude && pin.longitude == longitude {
                    self.pinToBePassed = pin
                    self.pinCoordinate = coordinateSelected
                }
            }
//            performSegue(withIdentifier: "PinPhotos", sender: coordinateSelected)
            mapView.deselectAnnotation(view.annotation, animated: false)
            
        } else {
            for pin in pins {
                if pin.latitude == latitude && pin.longitude == longitude {
                    let pinToDelete = pin
                    dataControllerClass.viewContext.delete(pinToDelete)
                    try? dataControllerClass.viewContext.save()
                }
            }
            mapView.removeAnnotation(view.annotation!)
        }
    }
}

