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
    var image: UIImage? { didSet { updateView() } }
    var pointFrame: CGRect {
        return pointManager.pointFrame
    }
    
    private let imageView = UIImageView()
    fileprivate let dimmingView = DimmingMaskView()
    private let pointManager = CropDragPointManager()
    
    override var intrinsicContentSize: CGSize {
        return imageView.intrinsicContentSize
    }
    
    init(image: UIImage) {
        self.image = image
        super.init(frame: CGRect(origin: .zero, size: image.size))
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
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        imageView.constrainEdgesToSuperview()
        
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dimmingView)
        dimmingView.constrainEdgesToSuperview()
        dimmingView.centerView.frame = pointFrame
        
        pointManager.allViews.forEach { self.addSubview($0) }
    }
    
    private func updateView () {
        backgroundColor = .clear
        imageView.image = image
    }
}

extension CropRectView: CropDragPointManagerDelegate {
    func cropDragPointManager(_ manager: CropDragPointManager, updatedFrame frame: CGRect) {
        dimmingView.centerView.frame = frame
    }
}
