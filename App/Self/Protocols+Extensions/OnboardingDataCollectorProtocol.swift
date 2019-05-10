import UIKit

protocol OnboardingDataCollectorDelegate: DataCollectionSequenceDelegate {
    var name: String? { get set }
}
