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
    let imagePadding: CGFloat = 40.0
    
    var image: UIImage? { didSet { updateUI() } }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
        updateUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateUI()
    }
    
    //MARK: Superclass
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.maximumZoomScale = 1.0
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.constrainEdgesToSuperview()
        scrollView.addSubview(imageView)
        
//        cropRectView.delegate = self
//        cropRectView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(cropRectView)
//        cropRectView.constrainEdgesToSuperview()
    }
    
    //MARK: Private
    
    private func updateUI() {
        imageView.image = image
        guard let image = image else { return }
        
        let imageRatio = image.size.width / image.size.height
        let viewRatio = view.bounds.width / view.bounds.height
        
        if imageRatio >= viewRatio {
            let imageSize = CGSize(width: image.size.width + imagePadding*2.0, height: image.size.height)
            let contentViewHeight = image.size.width * view.bounds.height / view.bounds.width
            let yOffset = (contentViewHeight - imageSize.height) / 2.0
            imageView.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            scrollView.minimumZoomScale = view.bounds.height / image.size.height
        } else {
            let imageSize = CGSize(width: image.size.width, height: image.size.height + imagePadding*2.0)
            let contentViewWidth = image.size.height * view.bounds.width / view.bounds.height
            let xOffset = (contentViewWidth - imageSize.width) / 2.0
            imageView.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            scrollView.minimumZoomScale = view.bounds.height / image.size.height
        }

        scrollView.contentSize = view.bounds.size
        scrollView.zoomScale = scrollView.minimumZoomScale
    }
}

extension CropViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

extension CropViewController: CropRectViewDelegate {
    func cropRectView(_ view: CropRectView, updatedFrame frame: CGRect) {
        
    }
}
