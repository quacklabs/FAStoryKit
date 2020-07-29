//
//  FAStoryAddView.swift
//  FAStoryKit
//
//  Created by Mark Boleigha on 29/07/2020.
//  Copyright © 2020 Ferhat Abdullahoglu. All rights reserved.
//
//

import UIKit
import AVFoundation
import SafariServices
import FAGlobalKit


protocol FAStoryAddDelegate: class {
//    func storyAdded
}

final public class FAStoryAddView: UIViewController, SwipeDismissInteractible {
    
    /// Interaction controller for dismissal
    public var dismissInteractionController: SwipeInteractionController?
    
    public var gestureView: UIView {
        return view
    }
    
    var delegate: FAStoryAddDelegate?
    
    // ==================================================== //
    // MARK: VC lifecycle
    // ==================================================== //
    public override func viewDidLoad() {
        super.viewDidLoad()
//        _init()
//        _configUI()
//        _gradSetup()
        
        //
        // Prepeare the dismiss interactor in case
        // the VC is not embedded in a navigationController
        // if it is, it's upto the navigationController
        // to decide whether or not to have a dismiss interaction controller
        //
        if navigationController == nil {
            dismissInteractionController = SwipeInteractionController(viewController: self)
        }
    }
    
    
    
}


extension FAStoryAddView: UIGestureRecognizerDelegate {
    
}
