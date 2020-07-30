//
//  FAStoryView.swift
//  FAStoryKit
//
//  Created by Ferhat Abdullahoglu on 6.07.2019.
//  Copyright © 2019 Ferhat Abdullahoglu. All rights reserved.
//

import UIKit

final public class FAStoryView: UIView {

    // ==================================================== //
    // MARK: UI Components
    // ==================================================== //
    @IBOutlet internal var storyView: UIView!
    
    @IBOutlet internal weak var collectionView: UICollectionView! 
    
    @IBOutlet internal weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet internal weak var collectionViewHeight: NSLayoutConstraint!
    
    lazy var addStoryButton: UIButton = {
        return addNewStoryButton()
    }()
    
    
    // ==================================================== //
    // MARK: Properties
    // ==================================================== //
    
    var addButtonImage: UIImage? = UIImage(named: "ic_plus") {
        didSet {
            self.addStoryButton.setImage(addButtonImage, for: .normal)
            self.addStoryButton.layoutIfNeeded()
        }
    }
    
    var addButtonText: String = "Add a story" {
        didSet {
            self.addStoryButton.setTitle(addButtonText, for: .normal)
            self.addStoryButton.layoutIfNeeded()
        }
    }
    
    var _font: UIFont? {
        didSet {
            self.addStoryButton.titleLabel?.font = _font!
            self.addStoryButton.setNeedsDisplay()
            self.addStoryButton.layoutIfNeeded()
        }
    }
    
    // -----------------------------------
    // Public properties
    // -----------------------------------
    /// FAStoryDataSource
    ///
    /// Reloads the collectionView data in case
    /// the collectionView was already loaded and
    /// the dataSource has changed afterwards
    public weak var dataSource: FAStoryDataSource? {
        didSet {
            DispatchQueue.main.async {
                self.stories = self.dataSource?.stories()
                FAStoryVcStack.shared.stories = self.stories
                guard let cv = self.collectionView else {return}
                cv.reloadData()
            }
        }
    }
    
    /// FAStoryDelegate
    public weak var delegate: FAStoryDelegate? {
        didSet {
            collectionViewHeight?.constant = (delegate?.cellHeight ?? DefaultValues.shared.cellHeight)
        }
    }
    // -----------------------------------
    
    
    // -----------------------------------
    // Private properties
    // -----------------------------------
    private var stories: [FAStory]?
    
    // -----------------------------------
    
    
    // ==================================================== //
    // MARK: Init
    // ==================================================== //
    public override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        _setupUI()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // initializing via storyboard
        // set the auto resizing mask
        translatesAutoresizingMaskIntoConstraints = true
        _setupUI()
    }
    
    // ==================================================== //
    // MARK: View lifecycle
    // ==================================================== //
    public override func awakeFromNib() {
        super.awakeFromNib()
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        collectionView?.reloadData()
    }
    
    
    // ==================================================== //
    // MARK: Methods
    // ==================================================== //
    
    func addNewStoryButton() -> UIButton {
        let addView = UIButton(type: .custom)
        addView.backgroundColor = .white
        addView.translatesAutoresizingMaskIntoConstraints = false
//        addView.
        
//        let btn = UIButton()
//        btn.layer.cornerRadius = 25
//        btn.layer.borderWidth = 1
//        btn.layer.borderColor = Colors.green.cgColor
////        btn.willSetContraints()
//        btn.setImage(UIImage(named: "ic_add")?.resize(to: CGSize(width: 25, height: 25)), for: .normal)
        
//        let text = Text(font: Font.body.make(withSize: 12), content: Localization.add_a_atory.attributed)
//        text.willSetContraints()
//        addView.addSubviews([btn, text])
        
//        NSLayoutConstraint.activate([
//            btn.centerXAnchor.constraint(equalTo: addView.centerXAnchor),
//            btn.topAnchor.constraint(equalTo: addView.topAnchor, constant: 5),
//            btn.heightAnchor.constraint(equalToConstant: 50),
//            btn.widthAnchor.constraint(equalToConstant: 50),
//
//            text.centerXAnchor.constraint(equalTo: addView.centerXAnchor),
//            text.topAnchor.constraint(equalTo: btn.bottomAnchor, constant: 5),
//        ])
        return addView
    }
    
    // -----------------------------------
    // Public methods
    // -----------------------------------
    /// hides the scroll indicators
    public func setScrollIndicators(hidden: Bool) {
        collectionView?.showsVerticalScrollIndicator = !hidden
        collectionView?.showsHorizontalScrollIndicator = !hidden
    }
    
    /// Sets the insets for the collectionView
    ///
    /// - Parameter insets: Insets to be set
    public func setContentInset(insets: UIEdgeInsets) {
        collectionView?.contentInset = insets
    }
    
    /// Let or block the bouncinf movement of the story container view
    /// - Parameter bounces: Pass __true__ to bounce
    public func setBouncesOnScroll(_ bounces: Bool) {
        collectionView?.alwaysBounceHorizontal = bounces
    }
    // -----------------------------------
    
    
    // -----------------------------------
    // Private methods
    // -----------------------------------
    private func _setupUI() {
//        self.addsub
        NSLayoutConstraint.activate([
            addStoryButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            addStoryButton.heightAnchor.constraint(equalToConstant: 80),
            addStoryButton.widthAnchor.constraint(equalToConstant: 80),
        ])
        
        if #available(iOS 11.0, *) {
            addStoryButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
            
        } else {
            // Fallback on earlier versions
            addStoryButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        }
        // load the nib file
//        let bundle = Bundle(for: FAStoryView.self)
//
//        bundle.loadNibNamed("FAStoryView", owner: self, options: nil)
//
//        addSubview(storyView)
//
//        storyView.frame = bounds
//        storyView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//
//        _cvSetup()
//
        /// subciribe to the story seen notification
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(_storySeen(_:)),
                                               name: .storySeen,
                                               object: nil)
        self.addStoryButton.addTarget(self, action: #selector(self._addStoryClicked), for: .touchUpInside)
    }
    
    
    /// prepares the collectionView for usage
    private func _cvSetup() {
        //
        // register collectionViewCell for usage
        //
        collectionView.register(FAStoryCollectionViewCell.self, forCellWithReuseIdentifier: FAStoryCollectionViewCell.ident)
        
        //
        // content inset for the leading edge
        //
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        
        //
        // delay touches
        //
        collectionView.delaysContentTouches = false
        
        collectionView.backgroundColor = .clear
    }
    
    /// calculates the cell size based on the current configuration
    private func _cellSize(height h: CGFloat, aspectRatio r: CGFloat, verticalPadding padding: CGFloat) -> CGSize {
        let _h = h - 2 * floor(padding)
        return CGSize(width: _h * r, height: _h)
    }
    
    /// story seen notirication selector
    @objc private func _storySeen(_ notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.collectionView?.reloadData()
        }
    }
    // -----------------------------------
    
    @objc func _addStoryClicked() {
//        Dispatch
        delegate?.addStoryClicked()
    }
}

//
// MARK: CollectionView Datasource
//
extension FAStoryView: UICollectionViewDataSource {
    /// Number of items = number of stories
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stories?.count ?? 0
    }
    
    /// Cell for stories
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FAStoryCollectionViewCell.ident, for: indexPath) as! FAStoryCollectionViewCell
        
        cell.setName(stories![indexPath.row].name,
                     font: delegate?.displayNameFont ?? DefaultValues.shared.displayNameFont,
                     color: delegate?.displayNameColor ?? DefaultValues.shared.displayNameColor)
        
        
        cell.backgroundColor = backgroundColor
        
        //
        // check the border settings for the cell
        //
        let w = delegate?.borderWidth ?? DefaultValues.shared.borderWidth ?? 0
        let c = stories![indexPath.row].isSeen ?
            (delegate?.borderColorSeen ?? DefaultValues.shared.borderColorSeen) :
            (delegate?.borderColorUnseen ?? DefaultValues.shared.borderColorUnseen)
            
        
        cell.setBorder(width: w, color: c)
        
        cell.storyIdent = stories![indexPath.row].ident
        
        if let image = stories?[indexPath.row].previewImage {
            cell.setImage(UIImage(data: image)!)
        }
        
        return cell
        
    }
    
    /// Number of sections -- in case the default value changes in future
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

//
// MARK: CollectionView Delegate
//
extension FAStoryView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    /// cell size
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     
        let h = delegate?.cellHeight ?? DefaultValues.shared.cellHeight
        let r = delegate?.cellAspectRatio ?? DefaultValues.shared.cellAspectRatio
        let p = delegate?.verticalCellPadding() ?? DefaultValues.shared.verticalCellPadding()
        
        return _cellSize(height: h, aspectRatio: r, verticalPadding: p)
    }
    
    /// horizontal spacing between items
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return delegate?.cellHorizontalSpacing ?? DefaultValues.shared.cellHorizontalSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return delegate?.cellHorizontalSpacing ?? DefaultValues.shared.cellHorizontalSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: delegate?.cellHorizontalSpacing ?? DefaultValues.shared.cellHorizontalSpacing, bottom: 0, right: delegate?.cellHorizontalSpacing ?? DefaultValues.shared.cellHorizontalSpacing)
    }
    
    /// user selected a cell
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelect(row: indexPath.row)
    }
    
}
