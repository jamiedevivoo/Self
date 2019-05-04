import UIKit
import Firebase


final class LoggingAMoodScreenSliderViewController: ScreenSliderViewController {
        var headline: String?
        var note: String?
        var arousalRating: Double?
        var valenceRating: Double?
    
        var wildcard: Mood.Wildcard?
        var emotion: Mood.Emotion?
        var tags = [Tag]()
    
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
    }
    
}


// MARK: - Setup Methods
private extension LoggingAMoodScreenSliderViewController {
    
    func setupScreens() -> [UIViewController] {
        let moodLoggingAMoodViewController = MoodLoggingMoodViewController()
        moodLoggingAMoodViewController.dataCollectionDelegate = self
        moodLoggingAMoodViewController.screenSlider = self
        
        let detailLoggingAMoodViewController = DetailLoggingMoodViewController()
        detailLoggingAMoodViewController.dataCollectionDelegate = self
        detailLoggingAMoodViewController.screenSlider = self
        
        let wildcardLoggingAMoodViewController = WildcardLoggingMoodViewController()
        wildcardLoggingAMoodViewController.dataCollectionDelegate = self
        wildcardLoggingAMoodViewController.screenSlider = self
        
        let overviewLoggingAMoodViewController = OverviewLoggingMoodViewController()
        overviewLoggingAMoodViewController.dataCollectionDelegate = self
        overviewLoggingAMoodViewController.screenSlider = self
        
        return [moodLoggingAMoodViewController,
                detailLoggingAMoodViewController,
                wildcardLoggingAMoodViewController,
                overviewLoggingAMoodViewController]
    }
    
}


// MARK: - Class Methods
extension LoggingAMoodScreenSliderViewController: DataCollectionSequenceDelegate {
    
    func validateDataBeforeNextScreen(nextViewController: UIViewController) -> Bool {
        
        if nextViewController.isKind(of: DetailLoggingMoodViewController.self) {
            if arousalRating == nil || valenceRating == nil  {
                return false
            }
        }
        
        
        return true
    }
    
    func setData(_ dataDict: [String:String?]) {
//        guard let name = dataDict["name"] else {
//            self.name = nil
//            return
//        }
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
extension LoggingAMoodScreenSliderViewController: ScreenSliderViewControllerDelegate {
    func reachedFirstIndex(_ pageSliderViewController: ScreenSliderViewController) {
        
    }
    
    func reachedFinalIndex(_ pageSliderViewController: ScreenSliderViewController) {
        
    }
    
}
