import UIKit
import SnapKit
import Firebase

final class AcknowledgementViewController: ViewController {
    
    // MARK: - SubViews
    lazy var headerLabel = HeaderLabel("Acknowledgement", HeaderLabel.HeaderType.section)
    lazy var exitButton = IconButton(UIImage(named: "back")!, action: #selector(exit), .standard)
    
    lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.App.Background.secondary()
        return view
    }()
    lazy var pageTipLabel: UILabel = {
        let label = UILabel()
        label.text = "About the App and how it was possible."
        label.textAlignment = .left
        label.textColor = UIColor.App.Text.text()
        label.numberOfLines = 0
        
        return label
    }()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
        
    }
    
    // Target Actions
    @objc func exit() {
        navigationController?.popViewController(animated: true)
    }
    
}

extension AcknowledgementViewController: ViewBuilding {
    
    func setupChildViews() {
        view.addSubview(topView)
        topView.addSubview(headerLabel)
        topView.addSubview(pageTipLabel)
        topView.addSubview(exitButton)
        
        topView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(pageTipLabel.snp.bottom).offset(20)
        }
        exitButton.applyConstraints(forPosition: .topLeft, inVC: self)
        headerLabel.snp.makeConstraints { make in
            make.centerY.equalTo(exitButton.snp.centerY)
            make.right.equalToSuperview().inset(30)
            make.left.equalTo(exitButton.snp.right).offset(5)
        }
        pageTipLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(30)
            make.top.equalTo(headerLabel.snp.bottom).offset(10)
        }
    }
}
