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
    override var frame: CGRect { didSet { updateView() } }
    override var bounds: CGRect { didSet { updateView() } }
    
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
    
    //MARK: Private
    
    private func configureView() {
        pointManager.delegate = self
        
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dimmingView)
        dimmingView.constrainEdgesToSuperview()
        dimmingView.centerView.frame = pointFrame
        
        pointManager.allViews.forEach { self.addSubview($0) }
    }
    
    private func updateView () {
        // no-op
    }
}

extension CropRectView: CropDragPointManagerDelegate {
    func cropDragPointManager(_ manager: CropDragPointManager, updatedFrame frame: CGRect) {
        dimmingView.centerView.frame = frame
        delegate?.cropRectView(self, updatedFrame: frame)
    }
}
