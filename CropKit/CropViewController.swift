//
//  CropViewController.swift
//  CropKit
//
//  Created by Dalton Claybrook on 3/31/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import UIKit

class CropViewController: UIViewController {
    
    let cropRectView = CropRectView()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cropRectView.delegate = self
        cropRectView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cropRectView)
        cropRectView.constrainEdgesToSuperview()
    }
    
    //MARK: Private
    
    private func updateImage() {
        cropRectView.image = image
    }
}

extension CropViewController: CropRectViewDelegate {
    func cropRectView(_ view: CropRectView, updatedFrame frame: CGRect) {
        
    }
}
