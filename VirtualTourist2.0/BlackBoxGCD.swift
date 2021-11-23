//
//  BlackBoxGCD.swift
//  VirtualTourist2.0
//
//  Created by Zakaria on 11/11/2021.
//

// Function to perform UI Updates on the mainQueue
import Foundation

// Perform UI updates on the main queue
func performUpdatesForUIOnTheMainQueue(_ updates: @escaping () ->Void){
    DispatchQueue.main.async {
        updates()
    }
}

func delay(_ seconds: Double , completion:@escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}
