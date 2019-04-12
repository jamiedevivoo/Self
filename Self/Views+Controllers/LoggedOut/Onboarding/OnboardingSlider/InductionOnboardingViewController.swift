//
//  InductionOnboardingViewController.swift
//  Self
//
//  Created by Jamie on 12/04/2019.
//  Copyright © 2019 Jamie De Vivo. All rights reserved.
//

import UIKit

class InductionOnboardingViewController: ViewController {
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Placeholder: You've begun a journey to your better self. (cheesy)"
        label.numberOfLines = 0
        label.textColor = UIColor.app.text.solidText()
        return label
    }()
    lazy var continueButton = StandardButton(title: "Continue", action: #selector(InductionOnboardingViewController.continueOnboarding), type: .primary)
    weak var onboardingFlowDelegate: OnboardingSliderViewController?
}

extension InductionOnboardingViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        addConstraints()
    }
}

extension InductionOnboardingViewController {
    @objc func continueOnboarding(_ sender: Any) {
        print("ButtonPressed")
        onboardingFlowDelegate?.nextStage()
    }
}

extension InductionOnboardingViewController: ViewBuilding {
    func addSubViews() {
        self.view.addSubview(label)
        self.view.addSubview(continueButton)
    }
    
    func addConstraints() {
        label.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.greaterThanOrEqualTo(100)
        }
        continueButton.snp.makeConstraints { (make) in
            make.top.equalTo(label.snp.bottom).offset(25)
            make.height.equalTo(60)
            make.width.equalToSuperview()
        }
    }
}
