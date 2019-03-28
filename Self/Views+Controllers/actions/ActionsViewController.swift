import UIKit

class ActionsViewController: UIViewController {
    
    lazy var actionsLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Actions 🙌"
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        label.textColor = UIColor.app.standard.solidText()
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        addConstraints()
    }
    
}

extension ActionsViewController: ViewBuilding {
    func addSubViews() {
        view.addSubview(actionsLabel)
    }
    
    func addConstraints() {
        actionsLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(20)
        }
    }
}
