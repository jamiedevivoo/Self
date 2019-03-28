import UIKit

class JournalViewController: UIViewController {
    
    lazy var achievementsView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var insightsView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var highlightLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Highlights 💪"
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        label.textColor = UIColor.app.standard.solidText()
        return label
    }()
    
    lazy var highlightStack: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        addConstraints()
    }
    
}

extension JournalViewController: ViewBuilding {
    func addSubViews() {
        view.addSubview(achievementsView)
        view.addSubview(insightsView)
        view.addSubview(highlightLabel)
        view.addSubview(highlightStack)
    }
    
    func addConstraints() {
        highlightLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(20)
        }
        highlightStack.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(20)
            make.bottom.equalToSuperview()
            make.top.equalTo(highlightLabel.snp.bottom).offset(20)
        }
    }
    
    
}
