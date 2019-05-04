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
        tintColor = UIColor.app.interactive.selectable.selected()
        pageIndicatorTintColor = UIColor.app.interactive.selectable.unselected()
        currentPageIndicatorTintColor = UIColor.app.interactive.selectable.selected()
    }
}
