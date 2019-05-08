import UIKit

class PageIndicator: UIPageControl {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        tintColor = UIColor.App.Interactive.Selectable.selected()
        pageIndicatorTintColor = UIColor.App.Interactive.Selectable.unselected()
        currentPageIndicatorTintColor = UIColor.App.Interactive.Selectable.selected()
    }
}
