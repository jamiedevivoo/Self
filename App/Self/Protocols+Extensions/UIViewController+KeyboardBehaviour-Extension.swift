import UIKit

extension UITextFieldDelegate where Self: UIViewController {
    
    // Helper function for setting up Gesture recogniser to dismiss current First Responder
    func configureKeyboardBehaviour(dissmisWhenTappingAway: Bool = true) {
        if dissmisWhenTappingAway {
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
        }
    }
}

// ViewController handler for dismissing keyboard
extension UIViewController {
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
