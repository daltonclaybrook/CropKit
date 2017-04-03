//
//  DimmingMaskView.swift
//  CropKit
//
//  Created by Dalton Claybrook on 4/1/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import UIKit

class DimmingMaskView: UIView {
    
    let centerView = UIView()
    
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
        backgroundColor = .clear
        isUserInteractionEnabled = false
        
        let topView = UIView()
        let rightView = UIView()
        let bottomView = UIView()
        let leftView = UIView()
        
        [topView, rightView, bottomView, leftView].forEach { view in
            view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
        
        centerView.translatesAutoresizingMaskIntoConstraints = true
        centerView.backgroundColor = .clear
        addSubview(centerView)
        
        topView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        topView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        topView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        topView.bottomAnchor.constraint(equalTo: centerView.topAnchor).isActive = true
        
        bottomView.topAnchor.constraint(equalTo: centerView.bottomAnchor).isActive = true
        bottomView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        bottomView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        leftView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        leftView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        leftView.rightAnchor.constraint(equalTo: centerView.leftAnchor).isActive = true
        leftView.bottomAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        
        rightView.leftAnchor.constraint(equalTo: centerView.rightAnchor).isActive = true
        rightView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        rightView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        rightView.bottomAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
    }
}
