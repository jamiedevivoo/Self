import UIKit
import SnapKit
import Firebase

class AddMoodViewController: ViewController {
    
    lazy var emotionPickerLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.app.text.solidText()
        label.text = "How are you?"
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        return label
    }()
    
    lazy var emotionLabel: UILabel = {
        let label = UILabel()
        label.text = "I am..."
        return label
    }()
    
    lazy var tagLabel: UILabel = {
        let label = UILabel()
        label.text = "Add a tag..."
        return label
    }()
    
    lazy var describeYourDay: UILabel = {
        let label = UILabel()
        label.text = "Describe your day..."
        return label
    }()
    
    lazy var wildcardQuestion: UILabel = {
        let label = UILabel()
        label.text = "Your Wildcard Question"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(emotionPickerLabel)
        getWildcard()
        self.navigationController?.pushViewController(MoodPickerViewController(), animated: true)
    }

}

extension AddMoodViewController {
    func getWildcard() {
        let wildcardRef:CollectionReference = Firestore.firestore().collection("wildcards")
        let randomDocumentID = String(Int.random(in: 0..<6))
        
        wildcardRef.document(randomDocumentID).getDocument { documentSnapshot, error in
            guard let documentSnapshot = documentSnapshot, error == nil else {
                if let error = error { print("Error Loading Actions: \(error.localizedDescription)") }
                print("Error Loading Actions.")
                return
            }
        print(documentSnapshot.data())
        }
    }
}
