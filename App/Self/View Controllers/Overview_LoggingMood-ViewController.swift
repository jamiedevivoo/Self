import UIKit
import Firebase
import SnapKit

final class OverviewLoggingMoodViewController: ViewController {
    
    weak var moodLogDataCollectionDelegate: MoodLoggingDelegate?
    weak var screenSliderDelegate: ScreenSliderViewController?
    
    lazy var headerLabel = HeaderLabel.init("Overview", .largeScreen)
    lazy var backButton = IconButton(UIImage(named: "up-circle")!, action: #selector(goBack), .standard)
}

// MARK: - Override Methods
extension OverviewLoggingMoodViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
        view.backgroundColor = .clear
        dismissKeyboard()
        screenSliderDelegate?.backwardNavigationEnabled = false
    }
    
}

// MARK: - Buttons
extension OverviewLoggingMoodViewController {
    
    @objc func goBack() {
        screenSliderDelegate?.backwardNavigationEnabled = true
        self.screenSliderDelegate?.previousScreen()
    }
}

// MARK: - View Building
extension OverviewLoggingMoodViewController: ViewBuilding {
    func setupChildViews() {
        self.view.addSubview(headerLabel)
        self.view.addSubview(backButton)
        headerLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.greaterThanOrEqualTo(50)
        }
        backButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).inset(15)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
    }
}
