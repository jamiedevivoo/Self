import UIKit

class StandardTextField: UITextField {

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
extension StandardTextField {
    convenience init(placeholder:String, fieldType:FieldType) {
        self.init()
        self.placeholder = placeholder
        customiseTextField(for: fieldType)
    }
//    convenience init(text: String, placeholder:String) {
//        self.text = text
//        self.init(placeholder: placeholder)
//    }
}

// Custom Styling
extension StandardTextField {
    func setupSubclass() {
        borderStyle = .none
        font = UIFont.systemFont(ofSize: 30)
        textColor = UIColor.app.text.solidText()
        returnKeyType = .next
        backgroundColor = .clear
        keyboardType = .default
        autocorrectionType = .no
        clearButtonMode = UITextField.ViewMode.whileEditing
        contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
    }

    func customiseTextField(for type: FieldType) {
        if type == .password {
            self.isSecureTextEntry = true
        } else if type == .email {
            keyboardType = .emailAddress
        }
    }
}

extension StandardTextField {
    enum FieldType {
        case text, email, password
    }
    
}
