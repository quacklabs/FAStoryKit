//
//  DKBreathView.swift
//  SessionKit
//
//  Created by Ferhat Abdullahoglu on 8.06.2019.
//  Copyright © 2019 Ferhat Abdullahoglu. All rights reserved.
//

import UIKit

@IBDesignable
public class DKBreathView: UIView {

    // ==================================================== //
    // MARK: IBOutlets
    // ==================================================== //
    
    /// Main view
    @IBOutlet internal var contentView: UIView!
    
    /// animated view
    @IBOutlet internal weak var animatedView: UIView!
    
    
    /// Message label
    @IBOutlet internal weak var lblMessage: UILabel!
    
    // ==================================================== //
    // MARK: IBActions
    // ==================================================== //
    
    
    
    // ==================================================== //
    // MARK: Properties
    // ==================================================== //
    
    // -----------------------------------
    // Public properties
    // -----------------------------------
    /// breath circle min aspect ratio
    @IBInspectable public var circleMinAspectRatio: CGFloat = 0.5
    
    /// breath circle max aspect ratio
    @IBInspectable public var circleMaxAspectRatio: CGFloat = 0.7
    
    /// inhale time
    @IBInspectable public var inhaleTime: Double = 3
    
    /// exhale time
    @IBInspectable public var exhaleTime: Double = 3
    
    /// animations have started
    public var isStarted = false
    
    // -----------------------------------
    
    // -----------------------------------
    // Internal properties
    // -----------------------------------
    
    
    
    // -----------------------------------
    // Private properties
    // -----------------------------------
    
    /// Animated view width constraint
    private var animatedViewWidthConstraint: NSLayoutConstraint!
    
    /// colors to be animated
    private var colors = [UIColor]() {
        didSet {
            _setupAnimatedView()
        }
    }
    
    // -----------------------------------
    
    
    // ==================================================== //
    // MARK: Init
    // ==================================================== //
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    
    
    // ==================================================== //
    // MARK: VC lifecycle
    // ==================================================== //
    override public func draw(_ rect: CGRect) {
        if let view = animatedView, view.layer.cornerRadius == 0 {
            view.layer.cornerRadius = view.frame.width / 2
        }
    }

    
    // ==================================================== //
    // MARK: Methods
    // ==================================================== //
    
    // -----------------------------------
    // Public methods
    // -----------------------------------
    /// Method to set the animation colors
    /// - parameter colors: Colors to be used
    public func setColors(_ colors: UIColor...) {
        colors.forEach({self.colors.append($0)})
    }
    
    /// Method to set the label text color
    /// - parameter color: Label text color
    public func setLabelColor(_ color: UIColor) {
        lblMessage?.textColor = color
    }
    
    /// Starts the animations
    public func start() {
        isStarted = true
        
        lblMessage.text = "Inhale".getLocalized()
        UIView.animateKeyframes(withDuration: inhaleTime,
                                delay: 0,
                                options: [.layoutSubviews, .beginFromCurrentState, .calculationModeLinear],
                                animations: { [weak self] in
                                    self?._inhale()
        }, completion: {[weak self] (_) in
            guard let wSelf = self else {return}
            wSelf.lblMessage.text = "Exhale".getLocalized()
            UIView.animateKeyframes(withDuration: wSelf.exhaleTime,
                                    delay: 0,
                                    options: [.layoutSubviews, .beginFromCurrentState, .calculationModeLinear],
                                    animations: {
                                        wSelf._exhale()
            }, completion: {[weak self] (_) in
                self?.start()
            })
        })
        
    }
 
  
    
    public func stop() {
        DispatchQueue.main.async {
            self.animatedView?.layer.removeAllAnimations()
            self.isStarted = false
        }
    }
    
    // -----------------------------------
    
    
    // -----------------------------------
    // Private methods
    // -----------------------------------
    
    /**
     Method to carry out internal initializations
     */
    private func _init() {
        
        // load the nib file
        guard let bundle = Bundle(identifier: DKSessionDataHandler.bundleId) else {return}
        
        bundle.loadNibNamed("DKBreathView", owner: self, options: nil)
        
        addSubview(contentView)
        
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        isUserInteractionEnabled = false
        
        _setupUI()
    }
    
    /**
     Method to setup the ui
     */
    private func _setupUI() {
        
        DispatchQueue.main.async {
            //
            // Set the initial aspect ratio for the aniamted view
            //
            self.animatedViewWidthConstraint = self.animatedView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: self.circleMinAspectRatio)
            self.animatedViewWidthConstraint.isActive = true
            
            //
            // Configure the animated view
            //
            self.animatedView.layer.masksToBounds = true
            self.animatedView.clipsToBounds = true
            
            self.lblMessage.text = "Inhale".getLocalized()
            
            self.backgroundColor = .clear

            
        }
        
    }
    
    /**
     Method to configure the animatedView bgColor
     */
    private func _setupAnimatedView() {
        DispatchQueue.main.async {
            self.animatedView.backgroundColor = self.colors.first
        }
    }
    
    /**
     Inhale animations
     */
    private func _inhale() {
        
        UIView.addKeyframe(withRelativeStartTime: 0,
                           relativeDuration: 1,
                           animations:  {
                            
                            let ratio = self.circleMaxAspectRatio / self.circleMinAspectRatio
                            
                            self.animatedView.transform = CGAffineTransform(scaleX: ratio, y: ratio)
                            
        })
        
        //
        // add the background color animations
        //
        let count = colors.count
        
        for idx in 1..<count {
            UIView.addKeyframe(withRelativeStartTime: Double(idx-1) * 1 / Double(count-1),
                               relativeDuration: 1 / Double(count-1)) {
                                self.animatedView.backgroundColor = self.colors[idx]
            }
        }

        
    }
    
    /**
     Exhale animations
     */
    private func _exhale() {
        
        UIView.addKeyframe(withRelativeStartTime: 0,
                           relativeDuration: 1,
                           animations:  {
                            
                            self.animatedView.transform = .identity
                            
        })
        
        //
        // add the background color animations
        //
        let count = colors.count - 1
        
        for idx in (0..<count).reversed() {
            UIView.addKeyframe(withRelativeStartTime: Double(count-idx-1) * 1 / Double(count),
                               relativeDuration: 1 / Double(count)) {
                                self.animatedView.backgroundColor = self.colors[idx]
            }
        }
        
    }
    
    /**
    Stop animations
     */
    private func _stop() {
        _exhale()
    }
    // -----------------------------------

}
