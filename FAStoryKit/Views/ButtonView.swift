//
//  ButtonView.swift
//  FAStoryKit
//
//  Created by Mark Boleigha on 31/07/2020.
//  Copyright © 2020 Sprinthub. MIT License
//

import UIKit

public class ButtonView: UIView {
    var imageView: UIImageView!
    var textView: UILabel!
    
    //    internal var clicked: (() -> Void)?
    public var clicked: (() -> Void)?
    
//    public var customView: UIView {
//        didSet {
//            _setupUI()
//        }
//    }
    public var image: UIImage?
    public var text: NSMutableAttributedString?
    public var font: UIFont?
    public var tint: UIColor?
    public var customView: UIView?
    var view: UIView!
    
    init() {
        super.init(frame: .zero)
        _setupUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func _setupUI() {
        self.backgroundColor = .white
        view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        
        self.imageView = UIImageView()
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.clipsToBounds = true
        
        self.textView = UILabel()
        textView.numberOfLines = 2
        textView.lineBreakMode = .byWordWrapping
        textView.textAlignment = .center
//        textView.textColor = tint ?? .black
        self.textView.translatesAutoresizingMaskIntoConstraints = false
        self.textView.clipsToBounds = true
        
        self.view.addSubview(imageView)
        self.view.addSubview(textView)
        
        self.addSubview(view)
        NSLayoutConstraint.activate([
            self.view.widthAnchor.constraint(equalToConstant: 60),
            self.view.heightAnchor.constraint(equalToConstant: 80),
            self.view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.view.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            self.imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.imageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10),
            self.imageView.heightAnchor.constraint(equalToConstant: 30),
            self.imageView.widthAnchor.constraint(equalToConstant: 30),
            
            self.textView.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 5),
            
            self.textView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -5),
            self.textView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.textView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        self.view.layer.borderColor = self.tint?.cgColor ?? UIColor.black.cgColor
        self.view.layer.borderWidth = 0.4
        self.view.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.view.layer.cornerRadius = 3
        self.imageView.image = image?.withRenderingMode( (tint != nil) ? .alwaysTemplate : .alwaysOriginal)
        self.imageView.tintColor = tint
        self.textView.attributedText = text
        self.textView.textColor = tint ?? UIColor.black
        self.textView.font = self.font ?? UIFont.systemFont(ofSize: 11)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.click)))
//        self.textView.setNeedsDisplay()
//        self.imageView.setNeedsDisplay()
        self.setNeedsDisplay()
        self.layoutIfNeeded()
    }
    
    public func apply() {
        self.subviews.forEach({
            $0.removeFromSuperview()
        })
        DispatchQueue.main.async {
            self._setupUI()
        }
    }
    
    @objc func click() {
        self.clicked?()
    }
//
}
