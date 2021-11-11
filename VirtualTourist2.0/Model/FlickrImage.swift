//
//  FlickrImage.swift
//  VirtualTourist2.0
//
//  Created by Zakaria on 11/11/2021.
//

import Foundation

struct FlickrImage {
    
    
    let photoPath : String?
    
    init(dictionary : [String:AnyObject]) {
        photoPath = dictionary[ClientForFlickr.JSONResponseKeys.MediumURL] as? String
    }
    
    static func photosPathFromResults(_ results: [[String:AnyObject]]) -> [FlickrImage] {
        var photosPath = [FlickrImage]()
        
        
        for result in results {
            photosPath.append(FlickrImage(dictionary: result))
        }
        return photosPath
        
    }
}
