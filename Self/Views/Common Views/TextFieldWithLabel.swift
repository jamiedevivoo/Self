import UIKit
import SnapKit

class TextFieldWithLabel: UIView {
    lazy var textField = StandardTextField(placeholder: "Placeholder..", fieldType: .text)
    lazy private var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .ultraLight)
        label.textColor = UIColor.app.text.solidText().withAlphaComponent(0.5)
        return label
    }()
    
    var labelTitle:String = "" {
        didSet {
            label.text = labelTitle
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
}

extension TextFieldWithLabel {
    func setup() {
        setupChildViews()
        backgroundColor = .clear
        
        label.addTapGestureRecognizer {
            self.textField.becomeFirstResponder()
        }
    }
    
    func resetHint(withText text: String? = nil) {
        guard let hintText = text else {
            label.textColor = UIColor.app.text.solidText().withAlphaComponent(0.5)
            label.text = labelTitle
            return
        }
        label.textColor = UIColor.red
        label.text = hintText
    }
}

extension TextFieldWithLabel: ViewBuilding {
    func setupChildViews() {
        addSubview(textField)
        addSubview(label)
        textField.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        label.snp.makeConstraints { (make) in
            make.top.equalTo(textField.snp.bottom).offset(-5)
            make.left.right.equalToSuperview()
            make.height.greaterThanOrEqualTo(20).priorityRequired()
            make.bottom.equalToSuperview()
        }
    }
}
