import UIKit
import SnapKit
import Firebase

final class TagsLoggingMoodViewController: ViewController {
    
    // Delegates and dependencies
    weak var dataCollector: MoodLoggingDelegate?
    weak var screenSliderDelegate: ScreenSliderViewController?
    
    // Views
    lazy var headerLabel = HeaderLabel.init("Tag Your Log", .largeScreen)
    lazy var hintOneLabel = ParaLabel(StaticMessages.get["hint"]["moodTag"][Int.random(in: 0 ..< StaticMessages.get["hint"]["moodTag"].count)]["text"].stringValue, .standard)
    
    lazy var tagTextFieldWithLabel: TextFieldWithLabel = {
        let textFieldWithLabel = TextFieldWithLabel()
        textFieldWithLabel.textField.font = UIFont.systemFont(ofSize: 36, weight: .light)
        textFieldWithLabel.textField.adjustsFontSizeToFitWidth = true
        textFieldWithLabel.textField.placeholder = "Tag name ..."
        textFieldWithLabel.textField.textColor = UIColor.App.Text.text().withAlphaComponent(0.9)
        textFieldWithLabel.labelTitle = "For example, what have you done today?"
        return textFieldWithLabel
    }()
    
    lazy var tagsCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 2
        flowLayout.minimumLineSpacing = 10
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.sectionInsetReference = .fromLayoutMargins
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: TagCell.reuseId)
        
        collectionView.backgroundColor = .clear
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
        }()
    
    lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.processTap))
    
    var tagHistory = [Tag]()
    
    var tags = [Tag]() {
        didSet {
            self.tagsCollectionView.reloadData()
            print(tags as AnyObject)
        }
    }
    
    var autoCompleteCharacterCount = 0
    var timer = Timer()
}

// MARK: - Override Methods
extension TagsLoggingMoodViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
        setupTextfield()
        view.backgroundColor = UIColor.white.withAlphaComponent(0)
        dataCollector?.tagManager.getAllTags { [unowned self] tags in
            if let tags = tags, tags.count > 0 {
                self.tagHistory = tags
            }
        }
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
        
        guard !tags.contains(where: {$0.title == tagTitle}) else {
            screenSliderDelegate?.forwardNavigationEnabled = false
            tagTextFieldWithLabel.resetHint(withText: "❗️You've already added this tag", for: .info)
            return nil
        }
        
        screenSliderDelegate?.forwardNavigationEnabled = true
        /// If it passes, reset the hint and show the next button
        tagTextFieldWithLabel.resetHint(withText: "+ Press next to add \(tagTitle) as a tag", for: .info)
        /// Then update the textfield
        tagTextFieldWithLabel.textField.text = tagTitle
        tagTextFieldWithLabel.textField.returnKeyType = UIReturnKeyType.next
        /// Finally return the validated value to the caller
        return tagTitle
    }
    
    @objc func removeTag(sender: TagButton) {
        tags = tags.filter({$0.title != sender.accountTag.title })
    }
}

// MARK: - TextField Delegate Methods
extension TagsLoggingMoodViewController: UITextFieldDelegate {
    
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
        let newTag = Tag(uid: nil, tagRef: nil, title: tagTitle, description: "", category: .personal, origin: .mood, valenceInfluence: 0, arousalInfluence: 0)
        
        guard !tags.contains(where: {$0.title == newTag.title}) else {
            return false
        }
        
        if let originalTag = tagHistory.first(where: {$0.title == newTag.title}) {
            self.tags.append(originalTag)
            dataCollector?.tags = self.tags
            return true
        }
        
        self.tags.append(newTag)
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
        cell.configure(tag: tags[indexPath.row])
        cell.button.addTarget(nil, action: #selector(removeTag), for: .touchUpInside)
        print(cell)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(collectionView, section)
        return tags.count
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout -
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(indexPath)
        let referenceHeight: CGFloat = 40 // Approximate height of your cell
        let referenceWidth: CGFloat = 100 
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

extension TagsLoggingMoodViewController {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool { //1
        var subString = (textField.text!.capitalized as NSString).replacingCharacters(in: range, with: string) // 2
        subString = formatSubstring(subString: subString)
        
        if subString.count == 0 { // 3 when a user clears the textField
            resetValues()
        } else {
            searchAutocompleteEntriesWIthSubstring(substring: subString) //4
        }
        return true
    }
    func formatSubstring(subString: String) -> String {
        let formatted = String(subString.dropLast(autoCompleteCharacterCount)).lowercased().capitalized //5
        return formatted
    }

    func resetValues() {
        autoCompleteCharacterCount = 0
        tagTextFieldWithLabel.textField.text = ""
    }
    
    func searchAutocompleteEntriesWIthSubstring(substring: String) {
        let userQuery = substring
        let suggestions = getAutocompleteSuggestions(userText: substring) //1
        
        if suggestions.count > 0 {
            timer = .scheduledTimer(withTimeInterval: 0.01, repeats: false, block: { (timer) in //2
                let autocompleteResult = self.formatAutocompleteResult(substring: substring, possibleMatches: suggestions) // 3
                self.putColourFormattedTextInTextField(autocompleteResult: autocompleteResult, userQuery: userQuery) //4
                self.moveCaretToEndOfUserQueryPosition(userQuery: userQuery) //5
            })
        } else {
            timer = .scheduledTimer(withTimeInterval: 0.01, repeats: false, block: { (timer) in //7
                self.tagTextFieldWithLabel.textField.text = substring
            })
            autoCompleteCharacterCount = 0
        }
    }
    
    func getAutocompleteSuggestions(userText: String) -> [String]{
        var possibleMatches: [String] = []
        for tag in tagHistory { //2
            let myString: NSString! = tag.title as NSString
            let substringRange: NSRange! = myString.range(of: userText)
            
            if (substringRange.location == 0) {
                possibleMatches.append(tag.title)
            }
        }
        return possibleMatches
    }
    
    func putColourFormattedTextInTextField(autocompleteResult: String, userQuery: String) {
        let colouredString: NSMutableAttributedString = NSMutableAttributedString(string: userQuery + autocompleteResult)
        colouredString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.App.Text.text().withAlphaComponent(0.2), range: NSRange(location: userQuery.count,length:autocompleteResult.count))
        self.tagTextFieldWithLabel.textField.attributedText = colouredString
    }
    func moveCaretToEndOfUserQueryPosition(userQuery: String) {
        if let newPosition = self.tagTextFieldWithLabel.textField.position(from: self.tagTextFieldWithLabel.textField.beginningOfDocument, offset: userQuery.count) {
            self.tagTextFieldWithLabel.textField.selectedTextRange = self.tagTextFieldWithLabel.textField.textRange(from: newPosition, to: newPosition)
        }
        let selectedRange: UITextRange? = tagTextFieldWithLabel.textField.selectedTextRange
        tagTextFieldWithLabel.textField.offset(from: tagTextFieldWithLabel.textField.beginningOfDocument, to: (selectedRange?.start)!)
    }
    func formatAutocompleteResult(substring: String, possibleMatches: [String]) -> String {
        var autoCompleteResult = possibleMatches[0]
        autoCompleteResult.removeSubrange(autoCompleteResult.startIndex..<autoCompleteResult.index(autoCompleteResult.startIndex, offsetBy: substring.count))
        autoCompleteCharacterCount = autoCompleteResult.count
        return autoCompleteResult
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
            make.top.equalTo(tagTextFieldWithLabel.snp.bottom).offset(20)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).inset(30)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).inset(60)
            make.bottom.equalToSuperview().offset(-100)
            
        }
    }
}
