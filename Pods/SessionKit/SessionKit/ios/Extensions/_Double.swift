//
//  _Double.swift
//  SessionKit
//
//  Created by Ferhat Abdullahoglu on 18.11.2018.
//  Copyright © 2018 Ferhat Abdullahoglu. All rights reserved.
//

import Foundation

//
// MARK: Extensions to Double
//
public extension Double {
    func toRadiants() -> Double {
        return self / 180.0 * Double.pi
    }
    
    func toCGFloat() -> CGFloat {
        return CGFloat(self)
    }
}
