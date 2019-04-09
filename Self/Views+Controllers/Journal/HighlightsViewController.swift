import UIKit
import Firebase
import SnapKit

class HighlightsViewController: UIViewController {
    
    lazy var achievementsView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var insightsView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var highlightLabel = ScreenHeaderLabel(title: "Your Highlights 💪")
    
    lazy var highlightStack: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        addConstraints()
    }
    
//    func getHighlights() {
//        let citiesRef = db.collection("cities")
//    }
    
}

extension HighlightsViewController: ViewBuilding {
    func addSubViews() {
        view.addSubview(highlightLabel)
        view.addSubview(achievementsView)
        view.addSubview(insightsView)
        view.addSubview(highlightLabel)
        view.addSubview(highlightStack)
    }
    
    func addConstraints() {
        highlightLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(75)
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
