import UIKit
import Firebase
import SnapKit

final class OverviewLoggingMoodViewController: ViewController {
    
    // Delegates and Dependencies
    weak var moodLogDataCollectionDelegate: MoodLoggingDelegate?
    weak var screenSliderDelegate: ScreenSliderViewController?
    
    // Views
    lazy var headerLabel = HeaderLabel.init("Overview", .largeScreen)
    lazy var backButton = IconButton(UIImage(named: "up-circle")!, action: #selector(goBack), .standard)
    lazy var saveButton = Button(title: "Save log", action: #selector(saveLog), type: .primary)
}

// MARK: - Override Methods
extension OverviewLoggingMoodViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
        view.backgroundColor = .clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        screenSliderDelegate?.backwardNavigationEnabled = false
        dismissKeyboard()
    }
    
}

// MARK: - Buttons
extension OverviewLoggingMoodViewController {
    
    @objc func goBack() {
        screenSliderDelegate?.backwardNavigationEnabled = true
        self.screenSliderDelegate?.previousScreen()
    }
    @objc func saveLog() {
        screenSliderDelegate?.backwardNavigationEnabled = true
        self.screenSliderDelegate?.previousScreen()
    }
}

// MARK: - View Building
extension OverviewLoggingMoodViewController: ViewBuilding {
    func setupChildViews() {
        self.view.addSubview(headerLabel)
        self.view.addSubview(backButton)
        self.view.addSubview(saveButton)
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
        saveButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(20)
            make.height.equalTo(60)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.centerX.equalToSuperview()
        }
    }
}
