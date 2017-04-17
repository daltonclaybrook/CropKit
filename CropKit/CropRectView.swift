//
//  CropRectView.swift
//  CropKit
//
//  Created by Dalton Claybrook on 3/31/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import UIKit

protocol CropRectViewDelegate: class {
    func cropRectView(_ view: CropRectView, updatedFrame frame: CGRect)
}

class CropRectView: UIView {
    
    weak var delegate: CropRectViewDelegate?
    var pointFrame: CGRect {
        return pointManager.pointFrame
    }
    
    fileprivate let dimmingView = DimmingMaskView()
    private let pointManager = CropDragPointManager()
    
    init() {
        super.init(frame: .zero)
        configureView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }
    
    //MARK: Public
    
    func setPointFrame(_ pointFrame: CGRect, animated: Bool) {
        guard dimmingView.bounds.contains(pointFrame) else { return }
        
        let duration: TimeInterval = animated ? 0.3 : 0.0
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: .beginFromCurrentState, animations: { 
            self.pointManager.updatePointFrame(pointFrame)
            self.dimmingView.centerView.frame = pointFrame
            self.dimmingView.layoutIfNeeded()
        }, completion: nil)
    }
    
    //MARK: Superclass
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for view in pointManager.allViews {
            if view.frame.contains(point) {
                return true
            }
        }
        return false
    }
    
    //MARK: Private
    
    private func configureView() {
        pointManager.delegate = self
        
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dimmingView)
        dimmingView.constrainEdgesToSuperview()
        dimmingView.centerView.frame = pointFrame
        
        pointManager.allViews.forEach { self.addSubview($0) }
    }
}

extension CropRectView: CropDragPointManagerDelegate {
    func cropDragPointManager(_ manager: CropDragPointManager, updatedFrame frame: CGRect) {
        dimmingView.centerView.frame = frame
        delegate?.cropRectView(self, updatedFrame: frame)
    }
}
