//
//  ViewController.swift
//  Me
//
//  Created by Jamie on 10/02/2019.
//  Copyright © 2019 Jamie De Vivo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var box = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(box)
        box.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(50)
            make.center.equalTo(self.view)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

