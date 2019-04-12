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
        borderStyle = .roundedRect
    }

    func customiseTextField(for type: FieldType) {
        if type == .password {
            self.isSecureTextEntry = true
        }
    }
}

extension StandardTextField {
    enum FieldType {
        case text, password
    }
    
}
