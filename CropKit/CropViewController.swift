//
//  CropViewController.swift
//  CropKit
//
//  Created by Dalton Claybrook on 3/31/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import UIKit

struct EdgeConstraints {
    let left: NSLayoutConstraint
    let top: NSLayoutConstraint
    let right: NSLayoutConstraint
    let bottom: NSLayoutConstraint
    
    func updateWithInsets(_ insets: UIEdgeInsets) {
        left.constant = insets.left
        top.constant = insets.top
        right.constant = insets.right
        bottom.constant = insets.bottom
    }
}

class CropViewController: UIViewController {
    
    let scrollView = UIScrollView()
    let cropRectView = CropRectView()
    let imageView = UIImageView()
    let imageContainerView = UIView()
    let imagePadding = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    fileprivate var paddingEdges: EdgeConstraints!
    fileprivate var centeringEdges: EdgeConstraints!
    
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
        
        paddingEdges = configureEdgeConstraints(forView: imageView, padding: imagePadding)
        centeringEdges = configureEdgeConstraints(forView: imageContainerView)
        
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
    
    private func configureEdgeConstraints(forView: UIView, padding: UIEdgeInsets? = nil) -> EdgeConstraints {
        assert(forView.superview != nil)
        let superview = forView.superview!
        
        let leftConstraint = forView.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: padding?.left ?? 0)
        let topConstraint = forView.topAnchor.constraint(equalTo: superview.topAnchor, constant: padding?.top ?? 0)
        let rightConstraint = superview.rightAnchor.constraint(equalTo: forView.rightAnchor, constant: padding?.right ?? 0)
        let bottomConstraint = superview.bottomAnchor.constraint(equalTo: forView.bottomAnchor, constant: padding?.bottom ?? 0)
        
        topConstraint.isActive = true
        rightConstraint.isActive = true
        bottomConstraint.isActive = true
        leftConstraint.isActive = true
        return EdgeConstraints(left: leftConstraint, top: topConstraint, right: rightConstraint, bottom: bottomConstraint)
    }
    
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
        paddingEdges.updateWithInsets(imagePadding.dividingByScale(minScale))
        
        view.layoutIfNeeded()
    }
    
    fileprivate func updateImageConstraints() {
        guard isViewLoaded, imageContainerView.bounds.size != .zero else { return }
        
        let yOffset = max(0, (view.bounds.height - imageContainerView.frame.height) / 2)
        centeringEdges.top.constant = yOffset
        centeringEdges.bottom.constant = yOffset
        
        let xOffset = max(0, (view.bounds.width - imageContainerView.frame.width) / 2)
        centeringEdges.left.constant = xOffset
        centeringEdges.right.constant = xOffset
        
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
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            correctCropRectFrame(animated: true)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        correctCropRectFrame(animated: true)
    }
}

extension CropViewController: CropRectViewDelegate {
    func cropRectView(_ view: CropRectView, updatedFrame frame: CGRect) {
        correctCropRectFrame(animated: false)
    }
}
