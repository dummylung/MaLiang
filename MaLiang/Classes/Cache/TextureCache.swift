//
//  TextureCache.swift
//  Atelier
//
//  Created by Lung on 27/6/2021.
//  Copyright © 2021 command b. All rights reserved.
//

import Foundation
import QuartzCore
import MetalKit

class TextureCache {
    
    static let shared = TextureCache()
    
    
    /// All textures created by this canvas
    open private(set) var textures: [MLTexture] = []
    
    /// make texture and cache it with ID
    ///
    /// - Parameters:
    ///   - data: image data of texture
    ///   - id: id of texture, will be generated if not provided
    /// - Returns: created texture, if the id provided is already exists, the existing texture will be returend
    @discardableResult
    func makeTexture(with data: Data, id: String? = nil) throws -> MLTexture {
        // if id is set, make sure this id is not already exists
        if let id = id, let exists = findTexture(by: id) {
            return exists
        }
        
        guard metalAvaliable else {
            throw MLError.simulatorUnsupported
        }
        let textureLoader = MTKTextureLoader(device: sharedDevice!)
        let texture = try textureLoader.newTexture(data: data, options: [.SRGB : false])
        let mltexture = MLTexture(id: id ?? UUID().uuidString, texture: texture)
        
        textures.append(mltexture)
        return mltexture
    }
    
    /// find texture by textureID
    open func findTexture(by id: String) -> MLTexture? {
        return textures.first { $0.id == id }
    }
    
//    func makeTexture(with file: URL, id: String? = nil) throws -> MLTexture {
//        let data = try Data(contentsOf: file)
//        return try makeTexture(with: data, id: id)
//    }
    
}
