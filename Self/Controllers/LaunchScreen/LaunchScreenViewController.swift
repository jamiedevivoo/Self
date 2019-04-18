import UIKit
import SnapKit

class LaunchScreenViewController: ViewController {

    lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to Self"
        label.font = UIFont.systemFont(ofSize: 36, weight: .heavy)
        label.textAlignment = .center
        label.textColor = UIColor.app.text.solidText()
        return label
    }()
    
    lazy var sliderViewController: LaunchScreenSliderViewController = {
        let viewController = LaunchScreenSliderViewController()
        self.addChild(viewController)
        return viewController
    }()
    
    lazy var buttonsViewController: LaunchScreenButtonsViewController = {
        let viewController = LaunchScreenButtonsViewController()
        self.addChild(viewController)
        return viewController
    }()
}

// MARK: Overides
extension LaunchScreenViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        title = "Welcome to Self"
        addSubViews()
        setupChildViews()
    }
}

// MARK: View Building
extension LaunchScreenViewController: ViewBuilding {
    
    func addChildViewController(viewController: UIViewController) {
        addChild(viewController)
        viewController.didMove(toParent: self)
    }
    
    func addSubViews() {
        self.view.addSubview(welcomeLabel)
        self.view.addSubview(sliderViewController.view)
        self.view.addSubview(buttonsViewController.view)
    }
    
    func setupChildViews() {
        welcomeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.width.equalToSuperview()
        }
        sliderViewController.view.snp.makeConstraints { (make) in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(35)
            make.bottom.equalTo(buttonsViewController.view.snp.top).inset(-20)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        buttonsViewController.view.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(150)
            make.centerX.equalToSuperview()
        }
    }
}
