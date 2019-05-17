import UIKit
import SnapKit
import Firebase
import NotificationBannerSwift

final class AppSettingsViewController: ViewController {
    
    // Dependencies and Delegates
    var user: UserInfo?

    // MARK: - Stored Properties
    /// None
    
    // MARK: - Views
    var headerLabel: HeaderLabel!
    var exitButton: IconButton!
    
    var topView: UIView!
    var pageTipLabel: UILabel!
    
    var colourMode = UIView()
    var colourLabel: HeaderLabel!
    var colourChoicesStack: UIStackView!
    
    var autoColourMode: Button!
    var lightColourMode: Button!
    var darkColourMode: Button!
    
    
    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AppSettingsViewController {
    private func setup() {
        headerLabel = HeaderLabel("App Settings", HeaderLabel.HeaderType.section)
        exitButton = IconButton(UIImage(named: "back")!, action: #selector(exit), .standard)
        autoColourMode = Button(title: "Magic", action: #selector(magicMode), type: .primary)
        lightColourMode = Button(title: "Light", action: #selector(lightMode), type: .secondary)
        darkColourMode = Button(title: "Dark", action: #selector(darkMode), type: .secondary)
        colourLabel = HeaderLabel("Preferred Colour Style", HeaderLabel.HeaderType.SmallScreen)
        colourChoicesStack = {
            let stack = UIStackView()
            stack.addArrangedSubview(autoColourMode)
            stack.addArrangedSubview(lightColourMode)
            stack.addArrangedSubview(darkColourMode)
            stack.axis = .horizontal
            stack.spacing = UIStackView.spacingUseDefault
            stack.alignment = UIStackView.Alignment.center
            stack.spacing = 5.0
            stack.distribution = UIStackView.Distribution.fillEqually
            return stack
        }()
        pageTipLabel = {
            let label = UILabel()
            label.text = "Use this page to modify app related settings."
            label.textAlignment = .left
            label.textColor = UIColor.App.Text.text()
            label.numberOfLines = 0
            
            return label
        }()
        topView = {
            let view = UIView()
            view.backgroundColor = UIColor.App.Background.secondary()
            return view
        }()
    }
}

extension AppSettingsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("CM:", AccountManager.shared().accountRef?.settings.userColorMode ?? .auto)
        switch AccountManager.shared().accountRef?.settings.userColorMode ?? .auto {
        case .light: lightMode()
        case .dark: darkMode()
        case .auto: magicMode()
        }
    }
    
    @objc func magicMode() {
        set(colourMode: .auto)
        autoColourMode.setup(.primary)
        autoColourMode.isEnabled = false
    }
    
    @objc func lightMode() {
        set(colourMode: .light)
        lightColourMode.setup(.primary)
        lightColourMode.isEnabled = false
    }
    @objc func darkMode() {
        set(colourMode: .dark)
        darkColourMode.setup(.primary)
        darkColourMode.isEnabled = false
    }
    
    private func set(colourMode: ColorManager.AppColorMode) {
        autoColourMode.setup(.secondary)
        autoColourMode.isEnabled = true
        lightColourMode.setup(.secondary)
        lightColourMode.isEnabled = true
        darkColourMode.setup(.secondary)
        darkColourMode.isEnabled = true
        
        guard AccountManager.shared().accountRef?.settings.userColorMode != colourMode else {
            return
        }
        
        AccountManager.shared().accountRef?.settings.userColorMode = colourMode
        save()
        ColorManager.updateColorMode()
        updateBackgroundColour()
    }
    
    private func save() {
        AccountManager.shared().updateAccount {
            let banner = NotificationBanner(title: "Success", subtitle: "App updated", style: .success)
            banner.bannerQueue.removeAll()
            banner.show(bannerPosition: .bottom)
        }
    }

    
    // Target Actions
    @objc func exit() {
        navigationController?.popViewController(animated: true)
    }
    
}

extension AppSettingsViewController: ViewBuilding {
    
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
        
        
        view.addSubview(colourMode)
        colourMode.addSubview(colourLabel)
        colourMode.addSubview(colourChoicesStack)

        colourMode.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(30)
            make.top.equalTo(topView.snp.bottom).offset(20)
            make.bottom.equalTo(autoColourMode.snp.bottom).offset(20)
        }
        colourLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.greaterThanOrEqualTo(20)
        }
        colourChoicesStack.snp.makeConstraints { make in
            make.top.equalTo(colourLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(80)
        }
        
        autoColourMode.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        lightColourMode.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        darkColourMode.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
    }
}
