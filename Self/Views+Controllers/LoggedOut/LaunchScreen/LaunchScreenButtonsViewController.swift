//
//  LaunchScreenButtonsViewController.swift
//  Self
//
//  Created by Jamie on 12/04/2019.
//  Copyright © 2019 Jamie De Vivo. All rights reserved.
//

import UIKit

class LaunchScreenButtonsViewController: UIViewController {
    lazy var registerButton = StandardButton(title: "Get Started", action: #selector(LaunchScreenButtonsViewController.navigateToRegister), type: .primary)
    lazy var loginButton = StandardButton(title: "Login", action: #selector(LaunchScreenButtonsViewController.navigateToLogin), type: .secondary)
}

// MARK: - Overrides
extension LaunchScreenButtonsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        addConstraints()
    }
}

// MARK: - Functions
extension LaunchScreenButtonsViewController {
    @objc func navigateToLogin(_ sender: Any) {
        navigationController?.pushViewController(LoginViewController(), animated: true)
    }
    @objc func navigateToRegister(_ sender: Any) {
        navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
}

// MARK: - View uilding
extension LaunchScreenButtonsViewController: ViewBuilding {
    func addSubViews() {
        view.addSubview(loginButton)
        view.addSubview(registerButton)
    }
    
    func addConstraints() {
        registerButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(loginButton.snp.top).inset(-20)
            make.width.equalToSuperview()
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
        }
        loginButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.width.equalToSuperview()
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
        }
    }
}
