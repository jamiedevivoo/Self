import UIKit
import Firebase
import SnapKit

final class OverviewLoggingMoodViewController: ViewController {
    
    // Delegates and Dependencies
    weak var dataCollector: MoodLoggingDelegate?
    weak var screenSliderDelegate: ScreenSliderViewController?
    
    // Views
    lazy var headerLabel = HeaderLabel.init("Log Overview", .largeScreen)
    
    lazy var logTitleLabel = HeaderLabel("Title", .subheader)
    lazy var logTitle = HeaderLabel(dataCollector!.headline!, .centerPageText)
    
    lazy var logTagsLabel = HeaderLabel("Log Tags", .subheader)
    lazy var tags = Button(title: "Tags", action: #selector(saveLog), type: .secondary)
    lazy var tagsView = UIView()
    
    lazy var wildcardView = UIView()
    lazy var logWildcardLabel = HeaderLabel("Question of the day", .subheader)
    lazy var logWildcardQuestion: UILabel = {
        let label = HeaderLabel(dataCollector!.wildcard?.question ?? "", .centerPageText)
        label.textAlignment = .center
        label.textColor = UIColor.App.General.blackWhite().withAlphaComponent(0.9)
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    lazy var wildcardButton: UIButton = {
        let button = Button(title: "+ Answer a question", action: #selector(addWildcard), type: .secondary)
        button.setTitleColor(UIColor.App.General.blackWhite().withAlphaComponent(0.8), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.borderColor = UIColor.App.General.blackWhite().withAlphaComponent(0.4).cgColor
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        return button
    }()

    lazy var noteView = UIView()
    lazy var logNoteLabel = HeaderLabel("Personal Note", .subheader)
    lazy var logNote: UILabel = {
        let label = HeaderLabel(dataCollector!.note?.text ?? "", .centerPageText)
        label.textAlignment = .center
        label.textColor = UIColor.App.General.blackWhite().withAlphaComponent(0.9)
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    lazy var noteButton: UIButton = {
        let button = Button(title: "+ Add a note", action: #selector(addNote), type: .secondary)
        button.setTitleColor(UIColor.App.General.blackWhite().withAlphaComponent(0.8), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.borderColor = UIColor.App.General.blackWhite().withAlphaComponent(0.4).cgColor
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        return button
    }()

    lazy var saveButton = Button(title: "✓ Save log", action: #selector(saveLog), type: .primary)
    
    lazy var tapTitle = UITapGestureRecognizer(target: self, action: #selector(OverviewLoggingMoodViewController.editTitle))
    lazy var tapTags = UITapGestureRecognizer(target: self, action: #selector(OverviewLoggingMoodViewController.editTags))
    lazy var tapWildcard = UITapGestureRecognizer(target: self, action: #selector(OverviewLoggingMoodViewController.addWildcard))
    lazy var tapNote = UITapGestureRecognizer(target: self, action: #selector(OverviewLoggingMoodViewController.addNote))

}

// MARK: - Override Methods
extension OverviewLoggingMoodViewController: UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
        view.backgroundColor = .clear
        logTitleLabel.isUserInteractionEnabled = true
        logTitleLabel.addGestureRecognizer(tapTitle)
        logTitle.addGestureRecognizer(tapTitle)
        logTagsLabel.addGestureRecognizer(tapTitle)
        //        tagsView.addGestureRecognizer(tapTitle)
        wildcardView.addGestureRecognizer(tapWildcard)
        logWildcardLabel.addGestureRecognizer(tapWildcard)
        noteView.isUserInteractionEnabled = true
        noteView.addGestureRecognizer(tapNote)
        logNoteLabel.addGestureRecognizer(tapNote)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        screenSliderDelegate?.pageIndicator.isVisible = false
        screenSliderDelegate?.forwardButton.isVisible = false
        UIView.animate(withDuration: 0.3, animations: {
            self.screenSliderDelegate?.backwardButton.alpha = 0.35
            self.screenSliderDelegate?.backwardButton.isEnabled = true
        })
        if dataCollector?.wildcard != nil {
            wildcardButton.removeFromSuperview()
            wildcardView.addSubview(logWildcardQuestion)
            logWildcardQuestion.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.height.greaterThanOrEqualTo(20)
                make.width.equalToSuperview()
                make.centerX.equalToSuperview()
            }
            guard let wildcardText: String = dataCollector?.wildcard?.answer else { return }
            logWildcardQuestion.text = wildcardText
        } else {
            logWildcardQuestion.removeFromSuperview()
            wildcardView.addSubview(wildcardButton)
            wildcardButton.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.height.greaterThanOrEqualTo(40)
                make.width.equalToSuperview()
                make.centerX.equalToSuperview()
            }
        }
        if dataCollector?.note != nil {
            noteButton.removeFromSuperview()
            noteView.addSubview(logNote)
            logNote.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.height.greaterThanOrEqualTo(20)
                make.width.equalToSuperview()
                make.centerX.equalToSuperview()
            }
            guard let noteText: String = dataCollector?.note?.text else { return }
            logNote.text = noteText
        } else {
            logNote.removeFromSuperview()
            noteView.addSubview(noteButton)
            noteButton.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.height.greaterThanOrEqualTo(40)
                make.width.equalToSuperview()
                make.centerX.equalToSuperview()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        screenSliderDelegate?.backwardNavigationEnabled = false
        screenSliderDelegate?.backwardButton.isEnabledStyle = true
        screenSliderDelegate?.gestureScrollingEnabled = false
        dismissKeyboard()
    }
    
}

// MARK: - Buttons
extension OverviewLoggingMoodViewController {
    
    @objc func saveLog() {
        screenSliderDelegate?.backwardNavigationEnabled = true
        dataCollector?.finishDataCollection()
    }
    @objc func editTitle() {
        guard let screen = screenSliderDelegate?.screens.firstIndex(where: {$0.vc.isKind(of: HeadlineLoggingMoodViewController.self)}) else { return }
        screenSliderDelegate?.goTo(index: screen)
    }
    @objc func editTags() {
        guard let screen = screenSliderDelegate?.screens.firstIndex(where: {$0.vc.isKind(of: TagsLoggingMoodViewController.self)}) else { return }
        screenSliderDelegate?.goTo(index: screen)
    }
    @objc func addWildcard() {
        guard let wildcardScreenIndex = screenSliderDelegate?.screens.firstIndex(where: {$0.vc.isKind(of: WildcardLoggingMoodViewController.self)}) else { return }
        screenSliderDelegate?.goTo(index: wildcardScreenIndex)
    }
    @objc func addNote() {
        guard let noteScreenIndex = screenSliderDelegate?.screens.firstIndex(where: {$0.vc.isKind(of: DiaryLoggingMoodViewController.self)}) else { return }
        screenSliderDelegate?.goTo(index: noteScreenIndex)
    }
}

// MARK: - View Building
extension OverviewLoggingMoodViewController: ViewBuilding {
    func setupChildViews() {
        // UI
        self.view.addSubview(headerLabel)
        
        // Log
        self.view.addSubview(logTitleLabel)
        self.view.addSubview(logTitle)
        
        self.view.addSubview(logTagsLabel)
        self.view.addSubview(tags)
        
        self.view.addSubview(logWildcardLabel)
        view.addSubview(wildcardView)
        
        self.view.addSubview(logNoteLabel)
        view.addSubview(noteView)
        
        self.view.addSubview(saveButton)
        
        // UI
        headerLabel.applyDefaultScreenHeaderConstraints(usingVC: self)
        
        // Log
        logTitleLabel.textAlignment = .center
        logTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headerLabel.snp.bottom).offset(30)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(20)
        }
        logTitle.textAlignment = .center
        logTitle.textColor = UIColor.App.General.blackWhite().withAlphaComponent(0.9)
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
        tags.setTitleColor(UIColor.App.General.blackWhite().withAlphaComponent(0.8), for: .normal)
        tags.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        tags.layer.borderColor = UIColor.App.General.blackWhite().withAlphaComponent(0.4).cgColor
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
        wildcardView.snp.makeConstraints { (make) in
            make.top.equalTo(logWildcardLabel.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(50)
        }
        
        logNoteLabel.textAlignment = .center
        logNoteLabel.snp.makeConstraints { (make) in
            make.top.equalTo(wildcardView.snp.bottom).offset(25)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(20)
        }
        noteView.snp.makeConstraints { (make) in
            make.top.equalTo(logNoteLabel.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(50)
        }
        
        saveButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(30)
            make.height.equalTo(60)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.centerX.equalToSuperview()
        }
    }
}
