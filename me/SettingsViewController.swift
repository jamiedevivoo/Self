//
//  SettingsViewController.swift
//  me
//
//  Created by Jamie De Vivo (i7436295) on 17/02/2019.
//  Copyright © 2019 Jamie De Vivo. All rights reserved.
//

import UIKit
import SnapKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("LOG: Settings Screen")

        view.backgroundColor = .gray
        
        let logoutButton = UIButton()
        logoutButton.backgroundColor = .black
        logoutButton.addTarget(self, action: #selector(SettingsViewController.logoutButton), for: .touchUpInside)
        logoutButton.setTitle("Logout", for: .normal)
        
        self.view.addSubview(logoutButton)
        
        UIView.animate(withDuration: 1) {
            logoutButton.snp.makeConstraints { (make) in
                make.size.equalTo(100)
                make.center.equalTo(self.view)
            }
        }
        
    }
    
    @objc func logoutButton() {
        print("Lougout Tapped")
        AppManager.shared.logout()
    }
    
}
