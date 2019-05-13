import UIKit
import Firebase

extension LoggingAMoodScreenSliderViewController: MoodLoggingDelegate { }

final class LoggingAMoodScreenSliderViewController: ScreenSliderViewController {
    
    // Delegates and Dependencies
    var moodManager: MoodManager = MoodManager(account: AccountManager.shared().accountRef!)
    var tagManager: TagManager = TagManager(account: AccountManager.shared().accountRef!)
    
    // Stored Properties
    var headline: String?
    var note: Note?
    var arousalRating: Double?
    var valenceRating: Double?

    var wildcard: Mood.Wildcard?
    var emotion: Mood.Emotion?
    var tags = [Tag]()
    
    var moodStage: MoodLoggingMoodViewController?
    var headlineStage: HeadlineLoggingMoodViewController?
    var tagsStage: TagsLoggingMoodViewController?
    var diaryStage: DiaryLoggingMoodViewController?
    var wildcardStage: WildcardLoggingMoodViewController?
    var overviewStage: OverviewLoggingMoodViewController?
    
    // Views
    lazy var background: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.frame = self.view.layer.frame
        layer.startPoint = CGPoint(x: 0.5, y: 0.5)
        layer.endPoint = CGPoint(x: 0, y: 0)
        layer.type = .conic
        layer.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor]
        return layer
    }()
    
    // Instance Manager
    init() {
        super.init(navigationOrientation: .vertical)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Override Methods
extension LoggingAMoodScreenSliderViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePageViewController(self, withPages: setupScreens(), withDelegate: self, showPageIndicator: true, isLooped: false, enableSwiping: false)
        navigationController?.navigationBar.isHidden = true
        self.modalTransitionStyle = .crossDissolve
        setupBackground()
    }
    
}

// MARK: - Setup Methods
extension LoggingAMoodScreenSliderViewController {
    
    func setupScreens() -> [(UIViewController, Bool)] {
        moodStage = MoodLoggingMoodViewController()
        moodStage!.dataCollector = self
        moodStage!.screenSliderDelegate = self
        
        headlineStage = HeadlineLoggingMoodViewController()
        headlineStage!.dataCollector = self
        headlineStage!.screenSliderDelegate = self
        
        tagsStage = TagsLoggingMoodViewController()
        tagsStage!.dataCollector = self
        tagsStage!.screenSliderDelegate = self
        
        diaryStage = DiaryLoggingMoodViewController()
        diaryStage!.dataCollector = self
        diaryStage!.screenSliderDelegate = self
        
        wildcardStage = WildcardLoggingMoodViewController()
        wildcardStage!.dataCollector = self
        wildcardStage!.screenSliderDelegate = self
        
        overviewStage = OverviewLoggingMoodViewController()
        overviewStage!.dataCollector = self
        overviewStage!.screenSliderDelegate = self
        
        // Return initial screens
        return [(moodStage!, true),
                (headlineStage!, true),
                (tagsStage!, true),
                (wildcardStage!, false),
                (diaryStage!, false),
                (overviewStage!, true)]
    }
    
    func setupBackground() {
        view.backgroundColor = UIColor.App.Background.primary()
        self.view.layer.insertSublayer(background, at: 0)
        let baseColour = UIColor(red: 0.5, green: 0.6, blue: 0.6, alpha: 0.4)
        background.colors = [baseColour.cgColor, baseColour.cgColor, baseColour.cgColor, baseColour.cgColor, baseColour.cgColor]
    }
    
}

// MARK: - Class Methods
extension LoggingAMoodScreenSliderViewController: DataCollectionSequenceDelegate, ScreenSliderDelegate {
    
    func validateDataBeforeNextScreen(currentViewController: UIViewController, nextViewController: UIViewController) -> Bool {
        if currentViewController.isKind(of: MoodLoggingMoodViewController.self) {
            guard arousalRating != nil, valenceRating != nil, emotion != nil else {
                return false
            }
        }
        
        if currentViewController.isKind(of: HeadlineLoggingMoodViewController.self) {
            guard headline != nil else {
                return false
            }
        }
        
        if currentViewController.isKind(of: TagsLoggingMoodViewController.self) {
            guard tags.count > 0 else {
                return false
            }
        }
        
        return true
    }
    
    func setData(_ dataDict: [String: Any?]) {}
    
    func isDataCollectionComplete() -> [String: Any]? {
        guard let headline = self.headline else { return nil }
        guard let valenceRating = self.valenceRating else { return nil }
        guard let arousalRating = self.arousalRating else { return nil }
        guard self.tags.count > 0 else { return nil }
        return ["headline": headline,
                "arousal_rating": arousalRating,
                "valence_rating": valenceRating,
        ]
    }
    
    func finishDataCollection() {
        guard var moodData = isDataCollectionComplete() else { return }
        moodData["timestamp"] = Date()
        if let wildcard = self.wildcard {
            moodData["wildcard"] = wildcard.dictionary
        }
        if let note = self.note {
            moodData["note"] = note.dictionary
        }
        
        /// first create the tags with uid's and ref's
        tags = tagManager.updateTag(self.tags)
        
        moodData["tags"] = tags.map({$0.dictionary})
        
        /// Then create the mood using them
        let mood: Mood.Log = Mood.Log(moodData)
        _ = moodManager.updateMood(mood)
        
        navigationController?.popToRootViewController(animated: true)
    }
    
}

// MARK: - ScreenSliderViewControllerDelegate Methods
extension LoggingAMoodScreenSliderViewController {
    func reachedFirstIndex(_ pageSliderViewController: ScreenSliderViewController) {
        
    }
    
    func reachedFinalIndex(_ pageSliderViewController: ScreenSliderViewController) {
        
    }
    
}
