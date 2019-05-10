import UIKit

final class Textfield: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubclass()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubclass()
    }
}

// MARK: - Convenience Init
extension Textfield {
    convenience init(placeholder: String, fieldType: FieldType) {
        self.init()
        self.placeholder = placeholder
        customiseTextField(for: fieldType)
    }
    convenience init(text: String, placeholder: String, fieldType: FieldType) {
        self.init()
        self.placeholder = placeholder
        customiseTextField(for: fieldType)
        self.text = text
    }
}

// Custom Styling
extension Textfield {
    func setupSubclass() {
        borderStyle = .none
        font = UIFont.systemFont(ofSize: 30)
        textColor = UIColor.App.Text.text()
        returnKeyType = .next
        backgroundColor = .clear
        keyboardType = .default
        autocorrectionType = .no
        clearButtonMode = UITextField.ViewMode.whileEditing
        contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        adjustsFontSizeToFitWidth = true
    }

    func customiseTextField(for type: FieldType) {
        if type == .password {
            self.isSecureTextEntry = true
        } else if type == .email {
            keyboardType = .emailAddress
        }
    }
}

extension Textfield {
    enum FieldType {
        case text, email, password
    }
    
}
