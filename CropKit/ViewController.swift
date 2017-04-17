//
//  ViewController.swift
//  CropKit
//
//  Created by Dalton Claybrook on 3/31/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let viewController = segue.destination as? CropViewController {
            viewController.image = #imageLiteral(resourceName: "profile")
//            viewController.image = #imageLiteral(resourceName: "tall")
            viewController.delegate = self
        }
    }
}

extension ViewController: CropViewControllerDelegate {
    
    func cropViewController(_ viewController: CropViewController, cropped image: UIImage) {
        dismiss(animated: true, completion: nil)
    }
}
