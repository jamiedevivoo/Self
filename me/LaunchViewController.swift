import UIKit
import SnapKit

class LaunchViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("LOG: Launch Screen")
        
        let loadingText = UILabel()
        
        loadingText.text = "Loading"

        self.view.addSubview(loadingText)
        
        loadingText.snp.makeConstraints { (make) in
            make.width.equalTo(200)
            make.height.equalTo(100)
            make.center.equalTo(self.view)
        }
        
        AppManager.shared.appContainer = self
        AppManager.shared.showApp()

    }

}
