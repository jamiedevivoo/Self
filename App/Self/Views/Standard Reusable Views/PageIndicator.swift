import UIKit

class PageIndicator: UIPageControl {
    
    var isVisible: Bool = true {
        willSet(newValue) {
            if newValue == true {
                UIView.animate(withDuration: 0.3,
                               animations: {
                                self.alpha = 0
                                self.frame.offsetBy(dx: 20, dy: 0)
                })
            } else {
                UIView.animate(withDuration: 0.3,
                               animations: {
                                self.alpha = 0.5
                                self.frame.offsetBy(dx: -20, dy: 0)
                })
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        isUserInteractionEnabled = false
        alpha = 0.4
        tintColor = UIColor.App.Interactive.Selectable.selected()
        pageIndicatorTintColor = UIColor.App.Interactive.Selectable.unselected()
        currentPageIndicatorTintColor = UIColor.App.Interactive.Selectable.selected()
        hidesForSinglePage = true
    }
}
