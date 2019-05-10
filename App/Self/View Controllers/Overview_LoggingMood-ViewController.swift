import UIKit
import Firebase
import SnapKit

final class OverviewLoggingMoodViewController: ViewController {
    
    // Delegates and Dependencies
    weak var moodLogDataCollectionDelegate: MoodLoggingDelegate?
    weak var screenSliderDelegate: ScreenSliderViewController?
    
    // Views
    lazy var headerLabel = HeaderLabel.init("Log Overview", .largeScreen)
    lazy var backButton = IconButton(UIImage(named: "up-circle")!, action: #selector(goBack), .standard)
    lazy var saveButton = Button(title: "Save log", action: #selector(saveLog), type: .primary)
    
    lazy var addWildcardButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "star-christmas")?.withRenderingMode(.alwaysTemplate)
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(image, for: .normal)
        button.setTitle("Answer a Wildcard", for: .normal)
        button.tintColor = UIColor(cgColor: moodLogDataCollectionDelegate?.background.colors![0] as! CGColor)
        button.layer.borderColor = UIColor.darkText.withAlphaComponent(0.05).cgColor
        button.layer.borderWidth = 3.0
        button.layer.shadowColor = UIColor.darkText.withAlphaComponent(0.8).cgColor
        button.layer.shadowOpacity = 0.6
        button.layer.shadowRadius = 8.0
        button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        button.layer.cornerRadius = 20
        button.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        return button
    }()
    
    lazy var addNoteButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "star-christmas")?.withRenderingMode(.alwaysTemplate)
        button.imageEdgeInsets = UIEdgeInsets(top: -10.0, left: 10.0, bottom: 0, right: 0)
        button.setTitle("Add a note", for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = UIColor(cgColor: moodLogDataCollectionDelegate?.background.colors![0] as! CGColor)
        button.setImage(image, for: .normal)
        button.layer.borderColor = UIColor.darkText.withAlphaComponent(0.05).cgColor
        button.layer.borderWidth = 3.0
        button.layer.shadowColor = UIColor.darkText.withAlphaComponent(0.8).cgColor
        button.layer.shadowOpacity = 0.6
        button.layer.shadowRadius = 8.0
        button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        button.layer.cornerRadius = 20
        button.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        return button
    }()
    
    lazy var logTitle = HeaderLabel(moodLogDataCollectionDelegate!.headline!, .centerPageText)
    
}

// MARK: - Override Methods
extension OverviewLoggingMoodViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
        view.backgroundColor = .clear
        logTitle.textAlignment = .center
        
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
        self.view.addSubview(backButton)
        self.view.addSubview(saveButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).inset(15)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
        saveButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(50)
            make.height.equalTo(60)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.centerX.equalToSuperview()
        }
        
        self.view.addSubview(logTitle)
        self.view.addSubview(headerLabel)
        self.view.addSubview(addWildcardButton)
        self.view.addSubview(addNoteButton)
        headerLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.greaterThanOrEqualTo(50)
        }
        logTitle.snp.makeConstraints { (make) in
            make.top.equalTo(headerLabel.snp.bottom).offset(30)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(50)
        }
        addWildcardButton.snp.makeConstraints { make in
            make.top.equalTo(logTitle.snp.bottom).offset(50)
            make.height.width.equalTo(100)
            make.centerX.equalToSuperview().offset(-80)
        }
        addNoteButton.snp.makeConstraints { make in
            make.top.equalTo(addWildcardButton.snp.top)
            make.height.width.equalTo(100)
            make.centerX.equalToSuperview().offset(80)
        }
    }
}
