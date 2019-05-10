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
    
    lazy var logTitleLabel = HeaderLabel("Title", .subheader)
    lazy var logTitle = HeaderLabel(moodLogDataCollectionDelegate!.headline!, .centerPageText)
    
    lazy var logTagsLabel = HeaderLabel("Log Tags", .subheader)
    lazy var tags = Button(title: "Tags", action: #selector(saveLog), type: .secondary)

    lazy var logWildcardLabel = HeaderLabel("Question of the day", .subheader)
    lazy var wildcardButton = Button(title: "+ Answer a question", action: #selector(addWildcard), type: .secondary)

    lazy var logNoteLabel = HeaderLabel("Personal Note", .subheader)
    lazy var noteButton = Button(title: "+ Add a note", action: #selector(addNote), type: .secondary)

    lazy var saveButton = Button(title: "✓ Save log", action: #selector(saveLog), type: .primary)
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

// MARK: - Class Methods
extension OverviewLoggingMoodViewController {
    
    func createTagViews() {
        for tag in moodLogDataCollectionDelegate!.tags {
            let view: UIView = UIView()
            let text = UILabel()
            text.text = tag
            view.backgroundColor = UIColor.white.withAlphaComponent(0.4)
            view.layer.cornerRadius = 10
        }
    }

}
// MARK: - Buttons
extension OverviewLoggingMoodViewController {
    
    @objc func goBack() {
        screenSliderDelegate?.backwardNavigationEnabled = true
        self.screenSliderDelegate?.goToPreviousScreen()
    }
    @objc func saveLog() {
        screenSliderDelegate?.backwardNavigationEnabled = true
        self.screenSliderDelegate?.goToNextScreen()
    }
    @objc func addWildcard() {
        guard let wildcardScreenIndex = screenSliderDelegate?.screens.firstIndex(where: {$0.vc.isKind(of: WildcardLoggingMoodViewController.self)}) else { return }
        screenSliderDelegate?.screens[wildcardScreenIndex].enabled = true
        goBack()
    }
    @objc func addNote() {
        guard let noteScreenIndex = screenSliderDelegate?.screens.firstIndex(where: {$0.vc.isKind(of: DiaryLoggingMoodViewController.self)}) else { return }
        screenSliderDelegate?.screens[noteScreenIndex].enabled = true
        goBack()
    }
}

// MARK: - View Building
extension OverviewLoggingMoodViewController: ViewBuilding {
    func setupChildViews() {
        // UI
        self.view.addSubview(headerLabel)
        self.view.addSubview(backButton)
        
        // Log
        self.view.addSubview(logTitleLabel)
        self.view.addSubview(logTitle)
        self.view.addSubview(logTagsLabel)
        self.view.addSubview(tags)
        self.view.addSubview(logWildcardLabel)
        self.view.addSubview(wildcardButton)
        self.view.addSubview(logNoteLabel)
        self.view.addSubview(noteButton)
        self.view.addSubview(saveButton)
        
        // UI
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
        
        // Log
        logTitleLabel.textAlignment = .center
        logTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headerLabel.snp.bottom).offset(30)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(20)
        }
        logTitle.textAlignment = .center
        logTitle.textColor = UIColor.white.withAlphaComponent(0.9)
        logTitle.snp.makeConstraints { (make) in
            make.top.equalTo(logTitleLabel.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(20)
        }
        
        logTagsLabel.textAlignment = .center
        logTagsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(logTitle.snp.bottom).offset(25)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(20)
        }
        tags.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: .normal)
        tags.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        tags.layer.borderColor = UIColor.white.withAlphaComponent(0.4).cgColor
        tags.layer.cornerRadius = 20
        tags.layer.borderWidth = 1
        tags.snp.makeConstraints { make in
            make.top.equalTo(logTagsLabel.snp.bottom).offset(10)
            make.height.equalTo(40)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.centerX.equalToSuperview()
        }
        
        logWildcardLabel.textAlignment = .center
        logWildcardLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tags.snp.bottom).offset(25)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(20)
        }
        wildcardButton.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: .normal)
        wildcardButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        wildcardButton.layer.borderColor = UIColor.white.withAlphaComponent(0.4).cgColor
        wildcardButton.layer.cornerRadius = 20
        wildcardButton.layer.borderWidth = 1
        wildcardButton.snp.makeConstraints { make in
            make.top.equalTo(logWildcardLabel.snp.bottom).offset(10)
            make.height.equalTo(40)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.centerX.equalToSuperview()
        }
        
        logNoteLabel.textAlignment = .center
        logNoteLabel.snp.makeConstraints { (make) in
            make.top.equalTo(wildcardButton.snp.bottom).offset(25)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(20)
        }
        noteButton.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: .normal)
        noteButton.layer.borderColor = UIColor.white.withAlphaComponent(0.4).cgColor
        noteButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        noteButton.layer.cornerRadius = 20
        noteButton.layer.borderWidth = 1
        noteButton.snp.makeConstraints { make in
            make.top.equalTo(logNoteLabel.snp.bottom).offset(10)
            make.height.equalTo(40)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.centerX.equalToSuperview()
        }
        
        saveButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(50)
            make.height.equalTo(60)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.centerX.equalToSuperview()
        }
    }
}
