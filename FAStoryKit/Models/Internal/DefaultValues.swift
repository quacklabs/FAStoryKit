//
//  DefaultValues.swift
//  FAStoryKit
//
//  Created by Ferhat Abdullahoglu on 7.07.2019.
//  Copyright © 2019 Ferhat Abdullahoglu. All rights reserved.
//

import UIKit

internal class DefaultValues: FAStoryDelegate {
    func addStoryClicked() { }
    
    
    /// internally shared singleton
    static var shared = DefaultValues()
    
    /// cell horizontal spacing
    var cellHorizontalSpacing: CGFloat {
        return 4
    }
    
    /// cell width
    var cellWidth: CGFloat {
        return 80
    }
    
    /// cell aspect ratio
    var cellAspectRatio: CGFloat {
        return 1
    }
    
    var borderWidth: CGFloat? {
        return 2
    }
    
    var borderColorSeen: UIColor? {
        return UIColor.lightGray.withAlphaComponent(0.4)
    }
    
    var borderColorUnseen: UIColor? {
        return UIColor.lightGray.withAlphaComponent(0.4)
    }
    
    /// display name font
    var displayNameFont: UIFont {
        return .systemFont(ofSize: 12)
    }
    
    func didSelect(row: Int) {  }
    
    func verticalCellPadding() -> CGFloat {
        return 4
    }
}
