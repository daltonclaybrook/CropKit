//
//  CropViewController.swift
//  CropKit
//
//  Created by Dalton Claybrook on 3/31/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import UIKit

class CropViewController: UIViewController {
    
    let scrollView = UIScrollView()
    let cropRectView = CropRectView()
    let imageView = UIImageView()
    let imageContainerView = UIView()
    let imagePadding = UIEdgeInsets(top: 64, left: 20, bottom: 100, right: 20)
    
    fileprivate var topConstraint: NSLayoutConstraint!
    fileprivate var rightConstraint: NSLayoutConstraint!
    fileprivate var bottomConstraint: NSLayoutConstraint!
    fileprivate var leftConstraint: NSLayoutConstraint!
    
    var image: UIImage? { didSet { updateImage() } }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
        updateImage()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: Superclass
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.constrainEdgesToSuperview()
        
        scrollView.addSubview(imageContainerView)
        imageContainerView.addSubview(imageView)
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.constrainEdgesToSuperview(with: imagePadding)
        
        topConstraint = imageContainerView.topAnchor.constraint(equalTo: scrollView.topAnchor)
        rightConstraint = scrollView.rightAnchor.constraint(equalTo: imageContainerView.rightAnchor)
        bottomConstraint = scrollView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor)
        leftConstraint = imageContainerView.leftAnchor.constraint(equalTo: scrollView.leftAnchor)
        
        topConstraint.isActive = true
        rightConstraint.isActive = true
        bottomConstraint.isActive = true
        leftConstraint.isActive = true
        
        cropRectView.delegate = self
        cropRectView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cropRectView)
        cropRectView.constrainEdgesToSuperview()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateZoomScale()
        correctCropRectFrame(animated: false)
    }
    
    //MARK: Private
    
    private func updateImage() {
        imageView.image = image
        imageView.layer.magnificationFilter = kCAFilterNearest
        view.layoutIfNeeded()
        
        cropRectView.setPointFrame(view.bounds, animated: false)
        updateZoomScale()
        updateImageConstraints()
        correctCropRectFrame(animated: false)
    }
    
    private func updateZoomScale() {
        guard isViewLoaded, imageContainerView.bounds.size != .zero else { return }
        
        let widthScale = view.bounds.width / imageContainerView.bounds.width
        let heightScale = view.bounds.height / imageContainerView.bounds.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = 100
        scrollView.zoomScale = minScale
    }
    
    fileprivate func updateImageConstraints() {
        guard isViewLoaded, imageContainerView.bounds.size != .zero else { return }
        
        let yOffset = max(0, (view.bounds.height - imageContainerView.frame.height) / 2)
        topConstraint.constant = yOffset
        bottomConstraint.constant = yOffset
        
        let xOffset = max(0, (view.bounds.width - imageContainerView.frame.width) / 2)
        leftConstraint.constant = xOffset
        rightConstraint.constant = xOffset
        
        view.layoutIfNeeded()
    }
    
    fileprivate func correctCropRectFrame(animated: Bool) {
        let imageViewFrame = imageView.convert(imageView.bounds, to: view)
        var pointFrame = imageViewFrame.intersection(cropRectView.pointFrame)
        if pointFrame.size == .zero {
            pointFrame = imageViewFrame
        }
        
        cropRectView.setPointFrame(pointFrame, animated: animated)
    }
}

extension CropViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageContainerView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateImageConstraints()
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        correctCropRectFrame(animated: true)
    }
}

extension CropViewController: CropRectViewDelegate {
    func cropRectView(_ view: CropRectView, updatedFrame frame: CGRect) {
        correctCropRectFrame(animated: false)
    }
}
