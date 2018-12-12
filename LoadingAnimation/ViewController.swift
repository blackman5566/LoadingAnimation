//
//  ViewController.swift
//  LoadingAnimation
//
//  Created by 許佳豪 on 2018/12/3.
//  Copyright © 2018 許佳豪. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var sampleView: UIView!
    
    @IBAction func buttonAction(_ sender: Any) {
        self.sampleView.startCovering()
    }
    
    @IBAction func stopAction(_ sender: Any) {
        self.sampleView.stopCovering()
    }
}

