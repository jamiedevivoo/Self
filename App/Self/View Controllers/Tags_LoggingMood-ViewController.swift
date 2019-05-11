import UIKit
import SnapKit
import Firebase

final class TagsLoggingMoodViewController: ViewController {
    
    // Delegates
    weak var dataCollector: MoodLoggingDelegate?
    weak var screenSliderDelegate: ScreenSliderDelegate?
    
    // Views
    lazy var headerLabel = HeaderLabel.init("Tag Your Log", .largeScreen)
    lazy var hintOneLabel = ParaLabel("Tags can be anything you want, from what you've done to how you felt 💡", .standard)
    
    lazy var tagTextFieldWithLabel: TextFieldWithLabel = {
        let textFieldWithLabel = TextFieldWithLabel()
        textFieldWithLabel.textField.font = UIFont.systemFont(ofSize: 36, weight: .light)
        textFieldWithLabel.textField.adjustsFontSizeToFitWidth = true
        textFieldWithLabel.textField.placeholder = "Tag name ..."
        textFieldWithLabel.labelTitle = "For example, what have you done today?"
        return textFieldWithLabel
    }()
    
    lazy var tagsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: TagCell.reuseId)
        
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
//        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).sectionInsetReference = .fromLayoutMargins

        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.processTap))
    
    // Stored Properties
    var tags: [Tag] = [] {
        didSet {
            tagsCollectionView.reloadData()
        }
    }
}

// MARK: - Override Methods
extension TagsLoggingMoodViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
        setupTextfield()
        view.backgroundColor = UIColor.white.withAlphaComponent(0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /// Update the textfield with the latest value
        tagTextFieldWithLabel.textField.placeholder = "A tag for \(dataCollector?.headline ?? "")"
        /// Revalidate the value and disable or enable navigation accordingly.
        if (dataCollector?.tags.count)! < 1 {
            tagTextFieldWithLabel.resetHint()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /// At this point forward navigation and gestureswping are enabled
        screenSliderDelegate?.backwardNavigationEnabled = true
        screenSliderDelegate?.gestureScrollingEnabled = true
        /// The page indicator is also visible on this page
        screenSliderDelegate?.pageIndicator.isVisible = true
        screenSliderDelegate?.backwardButton.isVisible = true
        screenSliderDelegate?.forwardButton.isVisible = true
        /// Add the tap gesture
        view.addGestureRecognizer(tapGesture)
        /// Finally, once the view has louaded, make the textfield Active if validation fails
     if (dataCollector?.tags.count)! < 1 {
            screenSliderDelegate?.forwardNavigationEnabled = false
//            tagTextFieldWithLabel.textField.becomeFirstResponder()
        } else {
            screenSliderDelegate?.forwardNavigationEnabled = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        /// If the view is about to dissapear we can resign the first responder
        tagTextFieldWithLabel.textField.resignFirstResponder()
    }
}

// MARK: - Class Methods
extension TagsLoggingMoodViewController {
    
    @objc func validateTagName() -> String? {
        /// Validation Checks
        guard
            let tagTitle: String = self.tagTextFieldWithLabel.textField.text?.trim(),
            self.tagTextFieldWithLabel.textField.text!.trim().count > 1
        /// Return nil if it fails
        else {
            if (dataCollector?.tags.count)! < 1 {
                tagTextFieldWithLabel.resetHint()
                screenSliderDelegate?.forwardNavigationEnabled = false
            } else {
                tagTextFieldWithLabel.resetHint(withText: "✓ Add another tag or press next again to continue", for: .info)
                screenSliderDelegate?.forwardNavigationEnabled = true
            }
            return nil
        }
        
        screenSliderDelegate?.forwardNavigationEnabled = true
        /// If it passes, reset the hint and show the next button
        tagTextFieldWithLabel.resetHint(withText: "+ Press next to add \(tagTitle) as a tag", for: .info)
        /// Then update the textfield
        tagTextFieldWithLabel.textField.returnKeyType = UIReturnKeyType.next
        /// Finally return the validated value to the caller
        return tagTitle
    }

//    func createTag(tagName: String) -> Tag {
//        return Tag()
//    }
    
    func createTagButton(tagName: String) -> UIButton {
        let button = UIButton()
        button.setTitle(tagName, for: .normal)
        button.addTarget(nil, action: #selector(removeTag), for: .touchUpInside)
//        tags.addArrangedSubview(button)
        return button
    }
    
    @objc func removeTag(sender: UIButton) {
        sender.removeFromSuperview()
    }
}

// MARK: - TextField Delegate Methods
extension TagsLoggingMoodViewController: UITextFieldDelegate {

//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        return false
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let tagTitle = validateTagName() else {
            
            // If the user has already added at least one tag, let them proceed with an error
            if (dataCollector?.tags.count)! > 0 {
                screenSliderDelegate?.goToNextScreen()
                return true
            }
            
            tagTextFieldWithLabel.textField.shake()
            tagTextFieldWithLabel.resetHint(withText: "Your log needs at least 1 tag (of 2 characters or more)", for: .error)
            return false
        }
        
        tagTextFieldWithLabel.textField.placeholder = "Another tag..."
        tagTextFieldWithLabel.resetHint(withText: "✓ Add another tag or press next again to continue", for: .info)
        textField.text = nil
        self.tags.append(Tag(title: tagTitle, description: "", category: .personal, origin: .mood, valenceInfluence: 0, arousalInfluence: 0))
        dataCollector?.tags = self.tags
        return true
        
        }
    
    func setupTextfield() {
        tagTextFieldWithLabel.textField.delegate = self
        tagTextFieldWithLabel.textField.addTarget(self, action: #selector(validateTagName), for: .editingChanged)
    }
}

extension TagsLoggingMoodViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    // MARK: - UICollectionViewDataSource -
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.reuseId, for: indexPath) as! TagCell
        cell.configure(text: tags[indexPath.row].title)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout -
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionInset = (collectionViewLayout as! UICollectionViewFlowLayout).sectionInset
        let referenceHeight: CGFloat = 100 // Approximate height of your cell
        let referenceWidth = collectionView.safeAreaLayoutGuide.layoutFrame.width
            - sectionInset.left
            - sectionInset.right
            - collectionView.contentInset.left
            - collectionView.contentInset.right
        return CGSize(width: referenceWidth, height: referenceHeight)
    }
}

// Gestures
extension TagsLoggingMoodViewController {
    @objc func processTap() {
        /// See if the current text validates
        guard validateTagName() == nil else {
            /// If it does, enable forward navigation and go to the next screen
            screenSliderDelegate?.goToNextScreen()
            return
        }
        
        /// If they have at elast one tag, let them proceed
        if (dataCollector?.tags.count)! > 0 {
            screenSliderDelegate?.goToNextScreen()
            return
        }
        
        /// If it fails and the keyboard isn't displayed, show the keyboard
        guard tagTextFieldWithLabel.textField.isFirstResponder else {
            tagTextFieldWithLabel.textField.becomeFirstResponder()
            return
        }
        
        /// If the keyboard is displayed, shake the textfield and prvide a hint
        tagTextFieldWithLabel.textField.shake()
        tagTextFieldWithLabel.resetHint(withText: "Your log needs at least 1 tag (of 2 characters or more)", for: .error)
    }
}

// MARK: - View Building
extension TagsLoggingMoodViewController: ViewBuilding {
    
    func setupChildViews() {
        self.view.addSubview(headerLabel)
        self.view.addSubview(tagTextFieldWithLabel)
        view.addSubview(tagsCollectionView)
        view.addSubview(hintOneLabel)
        hintOneLabel.alpha = 0.5
        hintOneLabel.textAlignment = .left
        
        hintOneLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-38)
            make.width.equalToSuperview().multipliedBy(0.65)
            make.left.equalToSuperview().offset(30)
            make.height.greaterThanOrEqualTo(30)
        }
        
        headerLabel.applyDefaultScreenHeaderConstraints(usingVC: self)
        tagTextFieldWithLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headerLabel.snp.bottom).offset(25)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(30)
            make.height.greaterThanOrEqualTo(60)
        }
        tagsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(tagTextFieldWithLabel.snp.bottom).offset(25)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(30)
            make.height.greaterThanOrEqualTo(40)
        }
    }
}
