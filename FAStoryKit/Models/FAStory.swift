//
//  FAStory.swift
//  FAStoryKit
//
//  Created by Ferhat Abdullahoglu on 6.07.2019.
//  Copyright © 2019 Ferhat Abdullahoglu. All rights reserved.
//

import UIKit


/// Main story container object
public class FAStory: NSObject, FAStoryTeller, Decodable {
    
    
    
    // ==================================================== //
    // MARK: Properties
    // ==================================================== //
    
    // -----------------------------------
    // Public properties
    // -----------------------------------
    /// Name of the story as seen on the highlights
    public var name: String!
    
    /// Story previewImage as seen on the highlights
    public var previewImageURL: String?
    
    public var previewImage: Data?
    
    /// Content(s) of the story
    public var content: [FAStoryAddible]?
    
    /// Nature of the content
    ///
    /// .builtIn || .online
    public var contentNature: FAStoryContentNature?
    
    /// id of the story if present
    public var ident: String
    
    /// flag that returns if th story has been watched before
    public var isSeen: Bool {
        get {
            return UserDefaults.standard.bool(forKey: storySeenKey)
        }
        
        set {
            DispatchQueue.global(qos: .userInteractive).async {
                NotificationCenter.default.post(name: .storySeen,
                                                object: nil,
                                                userInfo: ["storyIdent":self.ident])
            }
        }
    }
    
    // -----------------------------------
    
    
    // -----------------------------------
    // Private properties
    // -----------------------------------
    /// CodingKeys for the json representation as these two differ
    /// from the actual property names
    ///
    /// - previewImage: Preview image key name
    /// - content: Content key name
    private enum CodingKeys: String, CodingKey {
        case name
        case previewImageURL = "previewAsset"
        case content = "contents"
        case contentNature
        case ident
    }
    
    /// story key for the UserDefaults
    private var storySeenKey: String {
        return "isStorySeen_\(ident)"
    }
    // -----------------------------------
    
    
    // ==================================================== //
    // MARK: Init
    // ==================================================== //
    
    
    /// Initializer for the Decodable protocol
    ///
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let nature = try values.decode(Int.self, forKey: .contentNature)
        let ident = try values.decodeIfPresent(String.self, forKey: .ident) ?? UUID().uuidString
        
        name = try values.decode(String.self, forKey: .name)
        contentNature = FAStoryContentNature(rawValue: nature)
        self.previewImageURL = try values.decode(String.self, forKey: .previewImageURL)
        self.ident = ident
        
        super.init()
        
        let content = try values.decode([_StoryContentWrapper].self, forKey: .content)
        
        for _wrapper in content {
            let contentType = _wrapper.contentType
            let assetName = _wrapper.assetName
            let duration = _wrapper.duration
            
            
            let externalUrl: URL?
            if let _path = _wrapper.interactionUrl, _path.isValidUrl() {
                externalUrl = URL(string: _path)
            } else {
                externalUrl = nil
            }
            
            let assetUrl: URL
            
            if let _url = URL(string: assetName) {
                assetUrl = _url
            } else {
                assetUrl = Bundle.main.url(forResource: assetName, withExtension: nil)!
                
            }
            
            
            switch contentType {
            case .image:
                let _content = FAStoryImageContent(assetURL: assetUrl, externUrl: externalUrl, duration: duration)
                _content.setContentNature(self.contentNature!)
                self.addContent(_content)
            case .video:
                let _content = FAStoryVideoContent(assetURL: assetUrl, externUrl: externalUrl, duration: duration)
                _content.setContentNature(self.contentNature!)
                self.addContent(_content)
            default:
                assert(false, "FAStory - Invalid content type, please implement the corresponding type.")
            }
        }
        
    }
    
    /// Full fledged initializer for a story object
    ///
    /// - parameter content: Any object that conforms to __FAStoryAddible__
    /// - parameter name: Name of the story object
    /// - parameter flag: True if the content is builtIn False if otherwise
//    public init(with content: FAStoryAddible, name: String, builtIn flag: Bool = true, preview image: UIImage? = nil, ident: String) {
//        self.name = name
//        self.content = [content]
//        self.contentNature = flag ? .builtIn : .online
//        self.ident = ident
//        self.previewImageURL = (image
//        //
//        super.init()
//        //
//    }
    
    /// Convenience initializer
    ///
    /// The created story object nature will be __builtIn__
    public override init() {
        contentNature = .builtIn
        ident = UUID().uuidString
        super.init()
    }

    
    // ==================================================== //
    // MARK: Methods
    // ==================================================== //
    
    // -----------------------------------
    // Public methods
    // -----------------------------------
    /// Method that adds a new content to this story
    public func addContent(_ content: FAStoryAddible) {
        if self.content != nil {
            self.content!.append(content)
        } else {
            self.content = [content]
        }
    }
    
    /// Method to save the story as seen before
    public func setSeen() {
        if isSeen {return}
        UserDefaults.standard.set(true, forKey: storySeenKey)
        isSeen = true
    }
    // -----------------------------------
    
    
    // -----------------------------------
    // Private methods
    // -----------------------------------
    
    // -----------------------------------
    
}
