import UIKit
import SnapKit

class LaunchScreenViewController: UIViewController {
    
    lazy var registerButton = StandardButton(title: "Get Started", action: #selector(LaunchScreenViewController.navigateToRegister), type: .primary)
    lazy var loginButton = StandardButton(title: "Login", action: #selector(LaunchScreenViewController.navigateToLogin), type: .secondary)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Welcome to Self"
        
        BackgroundManager.shared.backgroundContainer = self
        BackgroundManager.shared.addBackgroundToView()
        
        addSubViews()
        addConstraints()
    }
    
    @objc func navigateToLogin(_ sender: Any) {
        navigationController?.pushViewController(LoginViewController(), animated: true)
        BackgroundManager.shared.fillScreen()
    }
    
    @objc func navigateToRegister(_ sender: Any) {
        navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
    
}

extension LaunchScreenViewController: ViewBuilding {
    func addSubViews() {
        view.addSubview(loginButton)
        view.addSubview(registerButton)
    }
    
    func addConstraints() {
        registerButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(loginButton.snp.top).inset(-20)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
        }
        loginButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
        }
    }
}
