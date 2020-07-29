//
//  _Extensions.swift
//  SessionKit
//
//  Created by Ferhat Abdullahoglu on 9.11.2018.
//  Copyright © 2018 Ferhat Abdullahoglu. All rights reserved.
//

import Foundation

internal extension String {
    // Method to get the localized version of a string - if it exists
    func getLocalized() -> String {
        let localized = NSLocalizedString(self, tableName: "TrBase", comment: "")
        if !localized.isEmpty {
            return localized
        } else {
            return self
        }
    }
}
