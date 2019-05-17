import UIKit
import SnapKit
import Firebase
import SafariServices

final class HelpSOSViewController: ViewController {
    
    // MARK: - SubViews
    lazy var headerLabel = HeaderLabel("Help Information", HeaderLabel.HeaderType.section)
    lazy var exitButton = IconButton(UIImage(named: "back")!, action: #selector(exit), .standard)
    
    lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.App.Background.secondary()
        return view
    }()
    lazy var pageTipLabel: UILabel = {
        let label = UILabel()
        label.text = "Sometimes things become too much to handle by ourselves, and that's okay. Here's some helpful advice and links for when that heppens."
        label.textAlignment = .left
        label.textColor = UIColor.App.Text.text()
        label.numberOfLines = 0
        
        return label
    }()
    lazy var headerOne = HeaderLabel("If someone is in immediate danger", HeaderLabel.HeaderType.SmallScreen)
    lazy var paraOne = ParaLabel("If you or someone else is in serious risk of death or injury, call 999 and ask for police, fire and/or ambulance.", ParaLabel.ParaType.standard)
    
    lazy var headerTwo = HeaderLabel("For other crisis situations", HeaderLabel.HeaderType.SmallScreen)
    lazy var paraTwo = ParaLabel("The first step to take is to call your GP or other allocated health professional (e.g Community Psychiatric Nurse (CPN)).  You will be able to make an emergency appointment to see your doctor, or speak to them on the phone.  For out-of-office hours, please call 111.", ParaLabel.ParaType.standard)
        lazy var mindUKWebsiteLink = Button(title: "Crisis Information from Mind UK", action: #selector(crisisInformation), type: Button.ButtonKind.secondary)
    
    lazy var headerThree = HeaderLabel("Someone to talk to", HeaderLabel.HeaderType.SmallScreen)
    lazy var paraThree = ParaLabel("If you are desperate to talk to someone, the Samaritans can help – they offer emotional support and a listening ear 24 hours a day, 365 days a year. This is a FREEPHONE number, which can even be called from a mobile that has no credit, and the call will not appear on the phone bill.", ParaLabel.ParaType.standard)
        lazy var callSamaritansLink = Button(title: "Call 116 123 (24hr)", action: #selector(callSamaritans), type: Button.ButtonKind.secondary)
        lazy var samaritansWebsiteLink = Button(title: "Samaritans Website", action: #selector(samaritanInformation), type: Button.ButtonKind.secondary)
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
        
    }
    
    // Target Actions
    @objc func exit() {
        navigationController?.popToRootViewController(animated: true)
    }
    @objc func crisisInformation() {
        if let url = URL(string: "https://www.mind.org.uk/information-support/guides-to-support-and-services/crisis-services/#.XN6rhTNKg3k") {
            let vc = SFSafariViewController(url: url)
            vc.delegate = self
            present(vc, animated: true)
        }
    }
    
    @objc func callSamaritans() {
        // Warning: You can't test this using the simulator
        if let url = URL(string: "tel://116123") {
            let vc = SFSafariViewController(url: url)
            vc.delegate = self
            present(vc, animated: true)
        }
    }
    @objc func samaritanInformation() {
        if let url = URL(string: "https://www.samaritans.org/how-we-can-help/contact-samaritan/") {
            let vc = SFSafariViewController(url: url)
            vc.delegate = self
            present(vc, animated: true)
        }
    }
    
}

extension HelpSOSViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        navigationController?.popToRootViewController(animated: true)
    }
}

extension HelpSOSViewController: ViewBuilding {
    
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
        
        view.addSubview(headerOne)
        view.addSubview(paraOne)
        view.addSubview(headerTwo)
        view.addSubview(paraTwo)
        view.addSubview(mindUKWebsiteLink)
        view.addSubview(headerThree)
        view.addSubview(paraThree)
        view.addSubview(callSamaritansLink)
        view.addSubview(samaritansWebsiteLink)

        headerOne.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(30)
            make.top.equalTo(topView.snp.bottom).offset(20)
            make.height.greaterThanOrEqualTo(20)
        }
            paraOne.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(30)
                make.top.equalTo(headerOne.snp.bottom).offset(10)
                make.height.greaterThanOrEqualTo(20)
            }
        
        headerTwo.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(30)
            make.top.equalTo(paraOne.snp.bottom).offset(20)
            make.height.greaterThanOrEqualTo(20)
        }
            paraTwo.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(30)
                make.top.equalTo(headerTwo.snp.bottom).offset(10)
                make.height.greaterThanOrEqualTo(20)
            }
            mindUKWebsiteLink.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(30)
                make.top.equalTo(paraTwo.snp.bottom).offset(10)
                make.height.equalTo(60)
            }
        
        headerThree.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(30)
            make.top.equalTo(mindUKWebsiteLink.snp.bottom).offset(20)
            make.height.greaterThanOrEqualTo(20)
        }
            paraThree.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(30)
                make.top.equalTo(headerThree.snp.bottom).offset(10)
                make.height.greaterThanOrEqualTo(20)
            }
            callSamaritansLink.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(30)
                make.top.equalTo(paraThree.snp.bottom).offset(10)
                make.height.equalTo(60)
            }
            samaritansWebsiteLink.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(30)
                make.top.equalTo(callSamaritansLink.snp.bottom).offset(10)
                make.height.equalTo(60)
            }
    }
}
