//
//  _DKSessionDataHandler.swift
//  SessionKit
//
//  Created by Ferhat Abdullahoglu on 28.12.2018.
//  Copyright © 2018 Ferhat Abdullahoglu. All rights reserved.
//

import Foundation

extension DKSessionDataHandler: DKCSIndexible {
    func indexingCompleted() {
        print("Indexing is completed successfully")
    }
    
    func indexingFailed(error: Error) {
        print("Indexing failed with: \(error.localizedDescription)")
    }
}
