import UIKit
import Firebase
import SnapKit

class HighlightsViewController: UIViewController {
    
    lazy var highlightLabel = HeaderLabel("Your Highlights 💪", type: .screen)
    
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
    
    var highlightsData = [Mood.Log]()
    
}

// MARK: - Init
extension HighlightsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addHighlights()
        addSubViews()
        setupChildViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
}

extension HighlightsViewController {
    func addHighlights() {
        print("Loading Highlights")
        HighlightManager.getHighlights() { [unowned self] allHighlights in
            for eachHighlight in allHighlights.documents {
                var highlightData = eachHighlight.data()
                highlightData["uid"] = eachHighlight.documentID
                let highlight = Mood.Log(highlightData)
                print(highlight as AnyObject)
                self.highlightsData.append(highlight)
                print("HGIHLIGHT LOADED")
                print(highlight as AnyObject)
            }
            self.highlightCollectionView.reloadData()
        }
    }
}

extension HighlightsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return highlightsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HighlightCell
        let highlight = highlightsData[indexPath.row]
        cell.actionCardTitleLabel.text = highlight.headline
        cell.actionCardDescriptionLabel.text = highlight.note
        for tag in highlight.tags {
            let tagButton = UIButton.tagButton
            tagButton.setTitle(tag.title, for: .normal)
            cell.tags.append(tagButton)
        }
        return cell
    }
    
}

// MARK: - View Building
extension HighlightsViewController: ViewBuilding {
    
    func setTabBarItem() {
        navigationController?.title = "Highlights"
        navigationController?.tabBarItem.image = UIImage(named: "highlight-glyph")
    }
    
    func addSubViews() {
        view.addSubview(highlightLabel)
        view.addSubview(highlightCollectionView)
    }
    
    func setupChildViews() {
        highlightLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(75)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
            make.height.lessThanOrEqualTo(50)
        }
        highlightCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(highlightLabel.snp.bottom).offset(20)
            make.right.left.equalToSuperview().inset(20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
