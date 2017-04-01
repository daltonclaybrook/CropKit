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
    
    private func configureView() {
        backgroundColor = .clear
        let topView = UIView()
        let rightView = UIView()
        let bottomView = UIView()
        let leftView = UIView()
        
        [topView, rightView, bottomView, leftView].forEach { view in
            view.backgroundColor = .green
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
        
        centerView.backgroundColor = .clear
        addSubview(centerView)
    }
}
