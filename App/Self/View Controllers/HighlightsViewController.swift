import UIKit
import Firebase
import SnapKit

class HighlightsViewController: UIViewController {
    
    // MARK: - Dependencies & Delegates
    var accountManager: AccountManager = AccountManager.shared()
    var actionManager: ActionManager = ActionManager()
    weak var moodManager: MoodManager?
    weak var insightManager: InsightManager?
    
    // MARK: - Views
    lazy var headerLabel = HeaderLabel("Your Highlights 💪", .smallScreen)
    
    lazy var loader = Loader(.content)
    
    lazy var highlightCollectionView: UICollectionView = { [unowned self] in
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 20
        flowLayout.minimumLineSpacing = 20
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(HighlightCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
        }()
    
    lazy var noHighlightsView = NoHighlightsView()
    
    // MARK: - Properties
    var actionLogs = [ActionManager.Log]() {
        didSet {
            self.highlightCollectionView.reloadData()
        }
    }
    
    var moodLogs = [Mood.Log]()
    var insightLogs = [Insight]()
}

// MARK: - Overrides
extension HighlightsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
        loader.animation.play()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addHighlights()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tabBarController?.returnedToRootView()
    }
    
}

// MARK: - Class Methods
extension HighlightsViewController {
    func addHighlights() {
        actionManager.user(accountManager.accountRef!).getCompleteActions { [weak self] actions in
            UIView.animate(
                withDuration: 0.25,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: 1,
                options: [.curveEaseInOut],
                animations: {
                    self?.loader.alpha = 0
            }, completion: { [weak self] _ in
                
            self?.loader.removeFromSuperview()
                
            print("stuff")
                
            // Check actions were returned
            guard let actions = actions, actions.count > 0 else {
                self?.addNoHighlightsView()
                self?.highlightCollectionView.removeFromSuperview()
                return
            }
            
            self?.actionLogs = actions
            self?.noHighlightsView.removeFromSuperview()
            self?.addHighlightsCollectionView()
            })
        }
    }
}

extension HighlightsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actionLogs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HighlightCell
        let highlight = actionLogs[indexPath.row]
        cell.actionCardTitleLabel.text = highlight.title
        cell.actionCardDescriptionLabel.text = highlight.description
        return cell
    }
    
}

// Mark - Adding Appropriate Views
extension HighlightsViewController {
    func addNoHighlightsView() {
        noHighlightsView.alpha = 0
        view.addSubview(noHighlightsView)
        noHighlightsView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.greaterThanOrEqualTo(125)
        }
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: [.curveEaseInOut],
            animations: {
                self.noHighlightsView.alpha = 1
        })
    }
    
    func addHighlightsCollectionView() {
        highlightCollectionView.alpha = 0
        view.addSubview(highlightCollectionView)
        highlightCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(headerLabel.snp.bottom).offset(20)
            make.right.left.equalToSuperview().inset(30)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: [.curveEaseInOut],
            animations: {
                self.highlightCollectionView.alpha = 1
        })
    }
}

// MARK: - View Building
extension HighlightsViewController: ViewBuilding {
    
    func setTabBarItem() {
        navigationController?.title = nil
        navigationController?.tabBarItem.image = UIImage(named: "heart")
    }
    
    func setupChildViews() {
        view.addSubview(headerLabel)
        view.addSubview(loader)
        
        headerLabel.applyDefaultScreenHeaderConstraints(usingVC: self)
        loader.snp.makeConstraints { make in
            make.width.height.equalTo(200)
            make.center.equalToSuperview()
        }
    }
}
