//
//  Codable+Extensions.swift
//  FAStoryKit
//
//  Created by Sprinthub on 29/07/2020.
//  Copyright © 2020 Ferhat Abdullahoglu. All rights reserved.
//

import Foundation

enum ImageType {
    case png
    case jpeg(quality: Double)
}

enum SDKError: Error {
    case imageConversionError
}

extension KeyedEncodingContainer {
    
    mutating func encode(_ value: UIImage,
                         forKey key: KeyedEncodingContainer.Key,
                         quality: ImageType = .png) throws {
        var imageData: Data!
        switch quality {
        case .png:
            imageData = value.pngData()
        case .jpeg(let quality):
            imageData = value.jpegData(compressionQuality: CGFloat(quality))
        }
        try encode(imageData, forKey: key)
    }
    
//    mutating func encode(_ value: Timer, forKey key: KeyedEncodingContainer.Key) {
//        var timer: Timer
//    }
    
}

extension KeyedDecodingContainer {
    
    public func decode(_ type: UIImage.Type, forKey key: KeyedDecodingContainer.Key) throws -> UIImage {
        let imageData = try decode(Data.self, forKey: key)
        if let image = UIImage(data: imageData) {
            return image
        } else {
            throw SDKError.imageConversionError
        }
    }
    
}
