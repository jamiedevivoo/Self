import UIKit

protocol MoodLoggingDelegate: DataCollectionSequenceDelegate {
    var background: CAGradientLayer { get set }
    var headline: String? { get set }
    var note: Note? { get set }
    var arousalRating: Double? { get set }
    var valenceRating: Double? { get set }
    
    var wildcard: Mood.Wildcard? { get set }
    var emotion: Mood.Emotion? { get set }
    var tags: [Tag] { get set }
}
