//
//  UserAccelerationEntry.swift
//  crashDetector
//
//  Created by Adam Teale on 7/09/2015.
//  Copyright © 2015 Adam Teale. All rights reserved.
//

import Foundation



struct UserAccelerationEntry {
    var userAccelerationX : Double = 0.0
    var userAccelerationY : Double = 0.0
    var userAccelerationZ : Double = 0.0
    
    func maxEntry() -> Double{
        let a = [self.userAccelerationX, self.userAccelerationY, self.userAccelerationZ].maxElement()
        return a!
    }
    
}