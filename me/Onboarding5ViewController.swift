//
//  Onboarding5ViewController.swift
//  me
//
//  Created by Jamie De Vivo (i7436295) on 20/02/2019.
//  Copyright © 2019 Jamie De Vivo. All rights reserved.
//

import UIKit

class Onboarding5ViewController: OnboardingViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let welcomeLabel = UILabel()
        let nextButton = UIButton()
        
        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(.blue, for: .normal)
        nextButton.addTarget(self, action: #selector(onboardingNext), for: .touchUpInside)
        
        welcomeLabel.text = "Welcome To Your Emotional Companion 5"
        welcomeLabel.textAlignment = .center
        welcomeLabel.lineBreakMode = .byWordWrapping
        welcomeLabel.numberOfLines = 3
        
        self.view.addSubview(welcomeLabel)
        self.view.addSubview(nextButton)
        
        welcomeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(50)
            make.left.equalTo(100)
            make.right.equalTo(-50)
            make.height.equalTo(50)
        }
        nextButton.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(self.view)
        }
    }
    
    @objc func onboardingNext(_ sender: Any) {
        print("Register Button Tapped")
        let nextOnboardingViewController = Onboarding1ViewController()
        navigationController?.pushViewController(nextOnboardingViewController, animated: true)
    }
    
}
