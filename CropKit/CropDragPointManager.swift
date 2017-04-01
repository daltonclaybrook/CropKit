//
//  CropDragPointView+Factory.swift
//  CropKit
//
//  Created by Dalton Claybrook on 3/31/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import UIKit

struct CropDragPointManager {
    
    let corners: [CropDragPointView]
    let sides: [CropDragPointView]
    var allViews: [CropDragPointView] {
        return corners + sides
    }
    
    init(bounds: CGRect) {
        let views = CropDragPointManager.createViews(in: bounds)
        corners = views.corners
        sides = views.sides
        (corners + sides).forEach { $0.delegate = self }
    }
    
    //MARK: Private
    
    private static func createViews(in bounds: CGRect) -> (corners: [CropDragPointView], sides: [CropDragPointView]) {
        let padding = CGPoint(x: 30, y: 30)
        let frame = bounds.insetBy(dx: padding.x, dy: padding.y)
        
        let topLeft = CropDragPointView(center: CGPoint(x: frame.minX, y: frame.minY))
        let topRight = CropDragPointView(center: CGPoint(x: frame.maxX, y: frame.minY))
        let bottomLeft = CropDragPointView(center: CGPoint(x: frame.minX, y: frame.maxY))
        let bottomRight = CropDragPointView(center: CGPoint(x: frame.maxX, y: frame.maxY))
        
        let left = CropDragPointView(center: CGPoint(x: frame.minX, y: frame.midY))
        let right = CropDragPointView(center: CGPoint(x: frame.maxX, y: frame.midY))
        let top = CropDragPointView(center: CGPoint(x: frame.midY, y: frame.minY))
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
            side.center = CGPoint(x: midX, y: midY)
        }
    }
}

extension CropDragPointManager: CropDragPointViewDelegate {
    func cropDragPointView(_ view: CropDragPointView, updatedCenter center: CGPoint) {
        updateAllSidePositions()
    }
}
