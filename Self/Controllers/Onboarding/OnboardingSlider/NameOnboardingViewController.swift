import UIKit

class NameOnboardingViewController: ViewController {
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Welcome to Self! What should we call you?"
        label.numberOfLines = 0
        label.textColor = UIColor.app.text.solidText()
        return label
    }()
    lazy var nameTextField = StandardTextField(placeholder: "Call me..", fieldType: .text)
    lazy var nameLabel = UILabel()
    
}
    
extension NameOnboardingViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        setupChildViews()
    }
}

extension NameOnboardingViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NameOnboardingViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension NameOnboardingViewController: ViewBuilding {
    func addSubViews() {
        self.view.addSubview(label)
        self.view.addSubview(nameTextField)
    }
    
    func setupChildViews() {
        label.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.height.greaterThanOrEqualTo(50)
        }
        nameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(label.snp.bottom).offset(25)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(60)
        }
    }
}
