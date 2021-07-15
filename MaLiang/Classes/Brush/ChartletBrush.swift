//
//  ChartletBrush.swift
//  MaLiang
//
//  Created by Harley-xk on 2020/10/26.
//

import Foundation
import CoreGraphics
import UIKit

/// A Brush that can draw specified chartlets on canvas
open class ChartletBrush: Printer {
    
    var textureIDs: [String] = []
    
    /// texture alignment
    public enum RenderStyle {
        case ordered, random
    }
    
    /// texture alignment, defaults to ordered
    open var renderStyle = RenderStyle.ordered
    
    open var pointRate: Double = 1.5
    
    open override var pointStep: CGFloat {
        get {
            return pointSize * CGFloat(pointRate)
        }
        set {
            pointRate = Double(newValue / pointSize)
        }
    }
    
    convenience public init(
        name: String?,
        textures: [MLTexture],
        renderStyle: RenderStyle = .ordered,
        target: Canvas? = nil
    ) {
        var id: String?
        let textureIDs = textures.map { $0.id }
        switch renderStyle {
        case .ordered: id = textureIDs[0]
        case .random: id = textureIDs.randomElement()
        }
        self.init(name: name, textureID: id, target: target)
        self.textureIDs = textureIDs
        self.renderStyle = renderStyle
    }
    
    required public init(name: String?, textureID: String?, target: Canvas? = nil) {
        super.init(name: name, textureID: textureID, target: target)
        opacity = 1
    }
    
    private var lastTextureIndex = 0
    
    private var nextIndex: Int {
        var index = lastTextureIndex + 1
        if index >= textureIDs.count {
            index = 0
        }
        return index
    }
    
    open func nextTextureID() -> String {
        switch renderStyle {
        case .ordered:
            let index = nextIndex
            let id = textureIDs[index]
            lastTextureIndex = index
            return id
        case .random:
            return textureIDs.randomElement()!
        }
    }
    
    open override func render(lines: [MLLine], on canvas: Canvas) {
        
        lines.forEach { (line) in
            let count = max(line.length / line.pointStep, 1)
            
            for i in 0 ..< Int(count) {
                let index = CGFloat(i)
                let x = line.begin.x + (line.end.x - line.begin.x) * (index / count)
                let y = line.begin.y + (line.end.y - line.begin.y) * (index / count)
                
                var angle: CGFloat = 0
                switch rotation {
                case let .fixed(a): angle = a
                case .random: angle = CGFloat.random(in: -CGFloat.pi ... CGFloat.pi)
                case .ahead: angle = line.angle
                }
                
                canvas.renderChartlet(
                    at: CGPoint(x: x, y: y),
                    size: CGSize(width: pointSize, height: pointSize),
                    textureID: nextTextureID(),
                    rotation: angle,
                    grouped: true
                )
            }
        }
    }
}
