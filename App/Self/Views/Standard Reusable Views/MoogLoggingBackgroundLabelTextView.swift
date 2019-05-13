import Foundation
import UIKit

class MoodloggingBackgroundTextView: CATextLayer {
    var moodLog: Mood.Log?
    
    override init() {
        super.init()
    }
    
    init(moodLog: Mood.Log? = nil) {
        self.moodLog = moodLog
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
