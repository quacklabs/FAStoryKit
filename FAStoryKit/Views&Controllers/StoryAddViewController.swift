//
//  StoryAddViewController.swift
//  FAStoryKit
//
//  Created by Sprinthub on 05/08/2020.
//  Copyright © 2020 Ferhat Abdullahoglu. All rights reserved.
//

import UIKit

public class StoryAddViewController: UIViewController {
    // ==================================================== //
    // MARK: UI Components
    // ==================================================== //
    
    lazy var composeView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    lazy var textInput: UITextView = {
        let inp = UITextView()
        inp.textColor = .white
        inp.textAlignment = .center
        inp.isEditable = true
        inp.backgroundColor = .clear
        inp.textContainer.lineBreakMode = .byWordWrapping
        inp.font = UIFont.boldSystemFont(ofSize: 23)
        inp.translatesAutoresizingMaskIntoConstraints = false
        inp.clipsToBounds = true
        inp.delegate = self
        return inp
    }()
    
    lazy public var doneButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Done", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.sizeToFit()
        return btn
    }()
    
    lazy public var cancelButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Cancel", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.sizeToFit()
        return btn
    }()
    
    lazy public var addMediaButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Add Image", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.sizeToFit()
        return btn
    }()
    
    lazy public var editColorButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Change Color", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.sizeToFit()
        return btn
    }()
    
    lazy public var removeImageButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Remove", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.isHidden = true
        btn.sizeToFit()
        return btn
    }()
    
    lazy var controlsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.isHidden = true
        return view
    }()
    
    // ==================================================== //
    // MARK: Properties
    // ==================================================== //
    public var delegate: FAStoryDelegate?
    var composeViewBottom: NSLayoutConstraint!
    var imageUsed: Bool = false
    
    // ==================================================== //
    // MARK: Methods
    // ==================================================== //
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self._init()
        self.setupActions()
    }
    
    // ==================================================== //
    // MARK: UI Setup
    // ==================================================== //
    
    private func _init() {
        //        self.view.backgroundColor = .black
        self.composeView.backgroundColor = Colors.all.randomElement()
        self.view.addSubview(self.composeView)
        
        if #available(iOS 11.0, *) {
            self.composeView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            // Fallback on earlier versions
            self.composeView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        }
        self.composeView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.composeView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        self.composeView.addSubview(self.textInput)
        
        
        let done = UIBarButtonItem(customView: doneButton)
        self.navigationItem.rightBarButtonItem = done
        
        let cancel = UIBarButtonItem(customView: cancelButton)
        self.navigationItem.leftBarButtonItem = cancel
        
        self.navigationController?.navigationBar.barTintColor = .black
        
        self.controlsView.addSubview(editColorButton)
        self.controlsView.addSubview(addMediaButton)
        self.controlsView.addSubview(removeImageButton)
        self.controlsView.addSubview(imageView)
        
        self.view.addSubview(controlsView)
        self.composeViewBottom = self.composeView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        NSLayoutConstraint.activate([
            composeViewBottom,
            
            textInput.leadingAnchor.constraint(equalTo: composeView.leadingAnchor, constant: 20),
            textInput.trailingAnchor.constraint(equalTo: composeView.trailingAnchor, constant: -20),
            textInput.centerXAnchor.constraint(equalTo: composeView.centerXAnchor),
            textInput.topAnchor.constraint(equalTo: composeView.topAnchor, constant: 100),
            textInput.bottomAnchor.constraint(equalTo: composeView.bottomAnchor, constant: -20),
            
            imageView.leadingAnchor.constraint(equalTo: composeView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: composeView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: composeView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: composeView.bottomAnchor),
            
            controlsView.heightAnchor.constraint(equalToConstant: 60),
            controlsView.leadingAnchor.constraint(equalTo: composeView.leadingAnchor),
            controlsView.trailingAnchor.constraint(equalTo: composeView.trailingAnchor),
            controlsView.topAnchor.constraint(equalTo: composeView.topAnchor),
            
            addMediaButton.leadingAnchor.constraint(equalTo: controlsView.leadingAnchor, constant: 20),
            addMediaButton.bottomAnchor.constraint(equalTo: controlsView.bottomAnchor, constant: -20),
            
            editColorButton.trailingAnchor.constraint(equalTo: controlsView.trailingAnchor, constant: -20),
            editColorButton.bottomAnchor.constraint(equalTo: controlsView.bottomAnchor, constant: -20),
            
            removeImageButton.trailingAnchor.constraint(equalTo: controlsView.trailingAnchor, constant: -20),
            removeImageButton.bottomAnchor.constraint(equalTo: controlsView.bottomAnchor, constant: -20),
        ])
        
        editColorButton.sizeToFit()
        addMediaButton.sizeToFit()
        textInput.sizeToFit()
        
        self.view.layoutIfNeeded()
    }
    
    private func setupActions() {
        DispatchQueue.main.async {
            self.subscribeToShowKeyboardNotifications()
            self.textInput.becomeFirstResponder()
        }
        
        self.cancelButton.addTarget(self, action: #selector(self.close), for: .touchUpInside)
        self.doneButton.addTarget(self, action: #selector(self.done), for: .touchUpInside)
        self.editColorButton.addTarget(self, action: #selector(self.changeColor), for: .touchUpInside)
        self.addMediaButton.addTarget(self, action: #selector(self.addImage), for: .touchUpInside)
        self.removeImageButton.addTarget(self, action: #selector(self.removeImage), for: .touchUpInside)
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func done() {
        if imageUsed {
            //            self.delegate?.storyAdded(story: )
        } else {
            if self.textInput.text == "" {
                self.dismiss(animated: true, completion: { return })
                return
            }
            guard let image = statusTextToImage() else {
                return
            }
        }
    }
    
    @objc func changeColor() {
        DispatchQueue.main.async {
            
            self.composeView.backgroundColor = Colors.custom != nil ? Colors.custom?.randomElement() : Colors.all.randomElement()
            self.view.backgroundColor = self.composeView.backgroundColor
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func removeImage() {
        self.imageView.image = nil
        self.imageUsed = false
        self.toggleRemoveImageButton(show: false)
    }
    
    func statusTextToImage() -> UIImage? {
        self.textInput.resignFirstResponder()
        self.textInput.sizeToFit()
        self.textInput.center = self.composeView.center
        
        
        // hide the controls view so it does not show in the image
        controlsView.isHidden = true
        
        let renderer = UIGraphicsImageRenderer(bounds: self.composeView.bounds)
        return renderer.image { rendererContext in
            self.composeView.layer.render(in: rendererContext.cgContext)
        }
        
    }
    
    @objc func addImage() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        //        picker.mediaTypes = []
        present(picker, animated: true)
    }
    
    // ==================================================== //
    // MARK: Keyboard Delegate
    // ==================================================== //
    
    func subscribeToShowKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        DispatchQueue.main.async {
            let userInfo = notification.userInfo
            let animationDuration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
//            let keyboardRect = userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect
            DispatchQueue.main.async {
                UIView.animate(withDuration: animationDuration) {
                    self.composeViewBottom.constant = 0
                }
            }
            
        }
    }
    
    @objc func keyboardDidShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let animationDuration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let keyboardRect = userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect
        DispatchQueue.main.async {
            UIView.animate(withDuration: animationDuration) {
                self.composeViewBottom.constant   = -keyboardRect.height
            }
        }
    }
}

extension StoryAddViewController: UITextViewDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text?.count == 240 {
            return false
        }
        return true
    }
}

extension StoryAddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if info[.editedImage] != nil {
            guard let image = info[.editedImage] as? UIImage else {
                return
            }
            toggleRemoveImageButton(show: true)
            self.imageView.image = image
        } else {
            guard let image = info[.originalImage] as? UIImage else {
                return
            }
            toggleRemoveImageButton(show: true)
            self.imageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func toggleRemoveImageButton(show: Bool) {
        self.imageUsed = show
        self.view.backgroundColor = show ? UIColor.black : self.composeView.backgroundColor
        self.editColorButton.isHidden = show
        self.removeImageButton.isHidden = show ? false : true
        
        self.composeView.isHidden = show ? true : false
        self.imageView.isHidden = show ? true : false
    }
}

