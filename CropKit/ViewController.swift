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
        }
    }
}

