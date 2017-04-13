//
//  CropDragPointView+Factory.swift
//  CropKit
//
//  Created by Dalton Claybrook on 3/31/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import UIKit

protocol CropDragPointManagerDelegate: class {
    func cropDragPointManager(_ manager: CropDragPointManager, updatedFrame frame: CGRect)
}

class CropDragPointManager {
    
    weak var delegate: CropDragPointManagerDelegate?
    let corners: [CropDragPointView] // topLeft, topRight, bottomRight, bottomLeft
    let sides: [CropDragPointView]
    var allViews: [CropDragPointView] {
        return corners + sides
    }
    var pointFrame: CGRect {
        var topLeft = corners[0].center
        var bottomRight = corners[2].center
        
        topLeft.x = min(topLeft.x, bottomRight.x)
        topLeft.y = min(topLeft.y, bottomRight.y)
        bottomRight.x = max(bottomRight.x, topLeft.x)
        bottomRight.y = max(bottomRight.y, topLeft.y)
        
        return CGRect(x: topLeft.x, y: topLeft.y, width: bottomRight.x - topLeft.x, height: bottomRight.y - topLeft.y)
    }
    
    fileprivate var lastFrame: CGRect?
    fileprivate var minimumSize = CGSize(width: 50, height: 50)
    
    init() {
        let views = CropDragPointManager.createViews()
        corners = views.corners
        sides = views.sides
        (corners + sides).forEach { $0.delegate = self }
    }
    
    public func updatePointFrame(_ frame: CGRect) {
        [frame.topLeft, frame.topRight, frame.bottomRight, frame.bottomLeft]
            .enumerated().forEach { corners[$0].center = $1 }
        updateAllSidePositions()
    }
    
    //MARK: Private
    
    private static func createViews() -> (corners: [CropDragPointView], sides: [CropDragPointView]) {
        let frame = CGRect(x: 30, y: 30, width: 100, height: 100)
        
        let topLeft = CropDragPointView(center: frame.topLeft)
        let topRight = CropDragPointView(center: frame.topRight)
        let bottomRight = CropDragPointView(center: frame.bottomRight)
        let bottomLeft = CropDragPointView(center: frame.bottomLeft)
        
        let left = CropDragPointView(center: CGPoint(x: frame.minX, y: frame.midY))
        let top = CropDragPointView(center: CGPoint(x: frame.midY, y: frame.minY))
        let right = CropDragPointView(center: CGPoint(x: frame.maxX, y: frame.midY))
        let bottom = CropDragPointView(center: CGPoint(x: frame.midX, y: frame.maxY))
        
        applyDirection(.both, toViews: [topLeft, topRight, bottomLeft, bottomRight])
        applyDirection(.leftRight, toViews: [left, right])
        applyDirection(.upDown, toViews: [top, bottom])
        
        applyXCorner(bottomLeft, yCorner: topRight, toView: topLeft)
        applyXCorner(bottomRight, yCorner: topLeft, toView: topRight)
        applyXCorner(topRight, yCorner: bottomLeft, toView: bottomRight)
        applyXCorner(topLeft, yCorner: bottomRight, toView: bottomLeft)
        
        left.centeredBetween = [topLeft, bottomLeft]
        top.centeredBetween = [topLeft, topRight]
        right.centeredBetween = [topRight, bottomRight]
        bottom.centeredBetween = [bottomLeft, bottomRight]
        
        return ([topLeft, topRight, bottomRight, bottomLeft], [top, right, bottom, left])
    }
    
    private static func applyDirection(_ direction: MovementDirection, toViews: [CropDragPointView]) {
        toViews.forEach { $0.direction = direction }
    }
    
    private static func applyXCorner(_ xCorner: CropDragPointView, yCorner: CropDragPointView, toView: CropDragPointView) {
        toView.linkedXCorner = xCorner
        toView.linkedYCorner = yCorner
    }
    
    fileprivate func updateAllSidePositions() {
        for side in sides {
            let midX = (side.centeredBetween[0].center.x - side.centeredBetween[1].center.x)/2.0 + side.centeredBetween[1].center.x
            let midY = (side.centeredBetween[0].center.y - side.centeredBetween[1].center.y)/2.0 + side.centeredBetween[1].center.y
            guard !midX.isNaN && !midY.isNaN else { continue }
            side.center = CGPoint(x: midX, y: midY)
        }
    }
}

extension CropDragPointManager: CropDragPointViewDelegate {
    func cropDragPointView(_ view: CropDragPointView, updatedCenter center: CGPoint) {
        let oldFrame = pointFrame
        var newFrame = oldFrame
        if let lastFrame = lastFrame {
            if newFrame.width < minimumSize.width {
                newFrame.origin.x = lastFrame.minX
                newFrame.size.width = lastFrame.width
            }
            if newFrame.height < minimumSize.height {
                newFrame.origin.y = lastFrame.minY
                newFrame.size.height = lastFrame.height
            }
        }
        
        if oldFrame != newFrame {
            updatePointFrame(newFrame)
        } else {
            updateAllSidePositions()
        }
        
        lastFrame = newFrame
        delegate?.cropDragPointManager(self, updatedFrame: newFrame)
    }
}

extension CGRect {
    var topLeft: CGPoint {
        return CGPoint(x: minX, y: minY)
    }
    var topRight: CGPoint {
        return CGPoint(x: maxX, y: minY)
    }
    var bottomRight: CGPoint {
        return CGPoint(x: maxX, y: maxY)
    }
    var bottomLeft: CGPoint {
        return CGPoint(x: minX, y: maxY)
    }
}
