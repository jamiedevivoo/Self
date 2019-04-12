import UIKit
import SnapKit

class LaunchScreenViewController: UIViewController {

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
        title = "Welcome to Self"
        addSubViews()
        addConstraints()
    }
}

// MARK: View Building
extension LaunchScreenViewController: ViewBuilding, AddingChildViewControllers {
    
    func addChildViewController(viewController: UIViewController) {
        addChild(viewController)
        viewController.didMove(toParent: self)
    }
    
    func addSubViews() {
        self.view.addSubview(sliderViewController.view)
        self.view.addSubview(buttonsViewController.view)
    }
    
    func addConstraints() {
        sliderViewController.view.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
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
