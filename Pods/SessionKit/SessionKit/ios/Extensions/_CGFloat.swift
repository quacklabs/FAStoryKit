//
//  _CGFloat.swift
//  SessionKit
//
//  Created by Ferhat Abdullahoglu on 18.11.2018.
//  Copyright © 2018 Ferhat Abdullahoglu. All rights reserved.
//

import Foundation

//
// MARK: Extensions to CGFloat
//
public extension CGFloat {
    func toRadiants() -> CGFloat {
        return self / 180.0 * CGFloat.pi
    }
    
    func toDouble() -> Double {
        return Double(self)
    }
}
