//
//  BrushCache.swift
//  Atelier
//
//  Created by Lung on 27/6/2021.
//  Copyright © 2021 command b. All rights reserved.
//

import Foundation
import QuartzCore
import MetalKit


class BrushCache {
    
    static let shared = BrushCache()
    
    /// All registered brushes
    open private(set) var registeredBrushes: [Brush] = []
    
    
    /// Register a brush with image data
    ///
    /// - Parameter texture: texture data of brush
    /// - Returns: registered brush
    @discardableResult open func registerBrush(brushClass: Brush.Type?, name: String? = nil, from data: Data) throws -> Brush {
        let texture = try TextureCache.shared.makeTexture(with: data)
        var brush: Brush!
        if let brushClass = brushClass {
            brush = brushClass.init(name: name, textureID: texture.id)
        } else {
            brush = Brush(name: name, textureID: texture.id)
        }
        registeredBrushes.append(brush)
        return brush
    }
    
    @discardableResult open func registerChartletBrush(name: String? = nil, datas: [Data]) throws -> Brush {
//        let textureIDs = try imageNames.compactMap { name -> String in
//            guard let image = UIImage(named: name) else {
//                throw MLError.imageNotExists(name)
//            }
//            guard let data = image.pngData() else {
//                throw MLError.convertPNGDataFailed
//            }
//            let texture = try TextureCache.shared.makeTexture(with: data)
//            return texture.id
//        }
        let textures = try datas.compactMap { try TextureCache.shared.makeTexture(with: $0) }
        let brush = ChartletBrush(name: name, textures: textures, renderStyle: .ordered, target: nil)
        registeredBrushes.append(brush)
        return brush
    }
    
    /// Register a brush with image data
    ///
    /// - Parameter file: texture file of brush
    /// - Returns: registered brush
//    @discardableResult open func registerBrush<T: Brush>(name: String? = nil, from file: URL) throws -> T {
//        let data = try Data(contentsOf: file)
//        return try registerBrush(name: name, from: data)
//    }
    
    /// Register a new brush with texture already registered on this canvas
    ///
    /// - Parameter textureID: id of a texture, default round texture will be used if sets to nil or texture id not found
//    open func registerBrush<T: Brush>(name: String? = nil, textureID: String? = nil) throws -> T {
//        let brush = T(name: name, textureID: textureID)
//        registeredBrushes.append(brush)
//        return brush
//    }
    
    /// Reigster an already initialized Brush to this Canvas
    /// - Parameter brush: Brush already initialized
    
//    open func register<T: Brush>(brush: T) {
////        brush.target = self
//        registeredBrushes.append(brush)
//    }
    
    /// find a brush by name
    /// nill will be retured if brush of name provided not exists
    open func findBrushBy(name: String?) -> Brush? {
        return registeredBrushes.first { $0.name == name }
    }
    
    
}
