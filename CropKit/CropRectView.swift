//
//  CropRectView.swift
//  CropKit
//
//  Created by Dalton Claybrook on 3/31/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import UIKit

class CropRectView: UIView {
    override var frame: CGRect { didSet { updateView() } }
    override var bounds: CGRect { didSet { updateView() } }
    
    var image: UIImage? { didSet { updateView() } }
    private let imageView = UIImageView()
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
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        imageView.constrainEdgesToSuperview()
        pointManager.allViews.forEach { self.addSubview($0) }
    }
    
    private func updateView () {
        backgroundColor = .clear
        imageView.image = image
    }
}

extension CropRectView: CropDragPointManagerDelegate {
    func cropDragPointManager(_ manager: CropDragPointManager, updatedFrame frame: CGRect) {
        print("\(frame)")
    }
}
