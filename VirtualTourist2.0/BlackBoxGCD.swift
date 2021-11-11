//
//  BlackBoxGCD.swift
//  VirtualTourist2.0
//
//  Created by Zakaria on 11/11/2021.
//

// Function to perform UI Updates on the mainQueue
import Foundation

func performUpdatesForUIOnTheMainQueue(_ updates: @escaping () ->Void){
    DispatchQueue.main.async {
        updates()
    }
}
