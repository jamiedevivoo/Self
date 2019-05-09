import UIKit
import Firebase

extension LoggingAMoodScreenSliderViewController: MoodLoggingDelegate { }

final class LoggingAMoodScreenSliderViewController: ScreenSliderViewController {
    var headline: String?
    var note: String?
    var arousalRating: Double?
    var valenceRating: Double?

    var wildcard: Mood.Wildcard?
    var diaryEntry: String?
    var emotion: Mood.Emotion?
    var tags = [String]()
    
    lazy var background: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.frame = self.view.layer.frame
        layer.startPoint = CGPoint(x: 0.5, y: 0.5)
        layer.endPoint = CGPoint(x: 0, y: 0)
        layer.type = .conic
        layer.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor]
        return layer
    }()
    
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
        configurePageViewController(self, withPages: setupScreens(), withDelegate: self, enableSwiping: false)
        self.view.layer.insertSublayer(background, at: 0)
        view.backgroundColor = UIColor.App.Background.primary()
        let baseColour = UIColor(red: 0.5, green: 0.6, blue: 0.6, alpha: 0.4)
        background.colors = [baseColour.cgColor, baseColour.cgColor, baseColour.cgColor, baseColour.cgColor, baseColour.cgColor]
    }
    
}

// MARK: - Setup Methods
extension LoggingAMoodScreenSliderViewController {
    
    func setupScreens() -> [UIViewController] {
        let moodStage = MoodLoggingMoodViewController()
        moodStage.moodLogDataCollectionDelegate = self
        moodStage.screenSliderDelegate = self
        
        let headlineStage = HeadlineLoggingMoodViewController()
        headlineStage.moodLogDataCollectionDelegate = self
        headlineStage.screenSliderDelegate = self
        
        let tagsStage = TagsLoggingMoodViewController()
        tagsStage.moodLogDataCollectionDelegate = self
        tagsStage.screenSliderDelegate = self
        
        let diaryStage = DiaryLoggingMoodViewController()
        diaryStage.moodLogDataCollectionDelegate = self
        diaryStage.screenSliderDelegate = self
        
        let wildcardStage = WildcardLoggingMoodViewController()
        wildcardStage.moodLogDataCollectionDelegate = self
        wildcardStage.screenSliderDelegate = self
        
        let overviewStage = OverviewLoggingMoodViewController()
        overviewStage.moodLogDataCollectionDelegate = self
        overviewStage.screenSliderDelegate = self
        
        return [moodStage,
                headlineStage,
                tagsStage,
                wildcardStage,
                diaryStage,
                overviewStage]
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
    
    func setData(_ dataDict: [String: Any?]) {
        guard let arousalRating: Double = dataDict["arousalRating"] as? Double else {
            self.arousalRating = nil
            return
        }
        
        guard let valenceRating: Double = dataDict["valenceRating"] as? Double else {
            self.valenceRating = nil
            return
        }
        
        guard let emotion: Mood.Emotion = dataDict["emotion"] as? Mood.Emotion else {
            self.emotion = nil
            return
        }
        
        self.arousalRating = arousalRating
        self.valenceRating = valenceRating
        self.emotion = emotion
        
////        guard let name = dataDict["name"] else {
//            self.name = nil
//            return
//        }
//        guard let name = dataDict["name"] else {
//            self.name = nil
//            return
//        }
//        guard let name = dataDict["name"] else {
//            self.name = nil
//            return
//        }
    }
    
    func isDataCollectionComplete() -> Bool {
//        guard let _ = self.name else { return false }
        return true
    }
    
    func finishDataCollection() {
//        guard let name = self.name else { return }
//        signInAnonymously(withName: name)
    }
    
}

// MARK: - ScreenSliderViewControllerDelegate Methods
extension LoggingAMoodScreenSliderViewController {
    func reachedFirstIndex(_ pageSliderViewController: ScreenSliderViewController) {
        
    }
    
    func reachedFinalIndex(_ pageSliderViewController: ScreenSliderViewController) {
        
    }
    
}
