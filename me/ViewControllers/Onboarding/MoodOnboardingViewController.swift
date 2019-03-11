import UIKit

class MoodOnboardingViewController: UIViewController {

    let onboardingIndex = 0
    var mood: Float?
    
    lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.app.background.primary
        return view
    }()
    lazy var pageTipLabel: UILabel = {
        let label = UILabel()
        label.text = "How are you today?"
        label.textAlignment = .left
        label.textColor = .darkText
        label.numberOfLines = 0

        return label
    }()
    lazy var moodTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Mood"
        return textField
    }()
    lazy var onboardingNextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(MoodOnboardingViewController.onboardingNextButtonAction), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        addConstraints()
    }
    
    
    // MARK: - Functions
    
    func setupView() {
        title = "How are you?"
        view.backgroundColor = .white
        navigationItem.leftBarButtonItems = nil
        
        self.view.addSubview(topView)
        topView.addSubview(pageTipLabel)
        self.view.addSubview(moodTextField)
        self.view.addSubview(onboardingNextButton)
    }
    
    @objc func onboardingNextButtonAction(_ sender: Any) {
        print("Bye Mood Controller")
        dismiss(animated: true, completion: nil)
    }

}

extension MoodOnboardingViewController: Onboarding {
}
extension MoodOnboardingViewController: OnboardingMoodViewDelegate {
}

extension MoodOnboardingViewController: ConstraintBuilding {
    func addConstraints() {
        topView.snp.makeConstraints { (make) in
            make.width.equalTo(self.view)
            make.height.equalTo(150)
            make.top.equalTo(0)
        }
        pageTipLabel.snp.makeConstraints { (make) in
            make.left.equalTo(topView.snp.left).offset(20)
            make.right.equalTo(topView.snp.right).offset(-20)
            make.top.equalTo(topView.snp.top).offset(100)
        }
        moodTextField.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-100)
            make.height.equalTo(35)
            make.top.equalTo(topView.snp.bottomMargin).offset(20)
        }
        onboardingNextButton.snp.makeConstraints { (make) in
            make.top.equalTo(moodTextField.snp.bottomMargin)
        }
    }
}
