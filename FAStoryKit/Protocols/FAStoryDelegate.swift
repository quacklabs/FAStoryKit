//
//  FAStoryDelegate.swift
//  FAStoryKit
//
//  Created by Ferhat Abdullahoglu on 6.07.2019.
//  Copyright © 2019 Ferhat Abdullahoglu. All rights reserved.
//

import UIKit

public protocol FAStoryDelegate: class {
    /// cell horizontal spacing
    var cellHorizontalSpacing: CGFloat {get}
    
    /// cell height
    var cellHeight: CGFloat {get}
    
    /// cell aspect ratio
    var cellAspectRatio: CGFloat {get}
    
    /// display name font
    var displayNameFont: UIFont {get}
    
    /// display name color
    var displayNameColor: UIColor {get}
    
    /// borderWidth
    var borderWidth: CGFloat? {get}
    
    /// borderColor for a story that's not seen
    var borderColorUnseen: UIColor? {get}
    
    /// borderColor for a story that's seen
    var borderColorSeen: UIColor? {get}
    
    /// vertical cell padding
    func verticalCellPadding() -> CGFloat
    
    /// did select
    func didSelect(row: Int) -> Void
        
    func storyAdded(story: FAStory) -> Void
    
}

public extension FAStoryDelegate {
    /// cell horizontal spacing
    var cellHorizontalSpacing: CGFloat {
        return DefaultValues.shared.cellHorizontalSpacing
    }
    
    /// cell width
    var cellHeight: CGFloat {
        return DefaultValues.shared.cellWidth
    }
    
    /// cell aspect ratio
    var cellAspectRatio: CGFloat {
        return DefaultValues.shared.cellAspectRatio
    }
    
    /// display name font
    var displayNameFont: UIFont {
        return DefaultValues.shared.displayNameFont
    }
    
    /// display name color
    var displayNameColor: UIColor {
        return .black
    }
    
    /// vertical cell padding
    func verticalCellPadding() -> CGFloat { return 4 }
    
    func storyAdded(story: FAStory) {
        
    }
}
