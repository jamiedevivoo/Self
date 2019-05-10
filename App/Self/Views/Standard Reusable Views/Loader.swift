import UIKit
import Lottie
import SnapKit

final class Loader: UIView {
    
    lazy var animation: AnimationView = AnimationView()
    
    init(_ type: LoaderType, _ layout: LoaderLayout = .icon) {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        /// Finish Setup
        addSubview(animation)
        setupAnimation(type)
        setupView(layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Loader {
    
    func setupAnimation(_ type: LoaderType) {
        animation.tintAdjustmentMode = UIView.TintAdjustmentMode.normal
        animation.tintColor = UIColor.white
        animation.contentMode = .scaleAspectFill
        
        switch type {
        case .content:
            animation.loopMode = LottieLoopMode.loop
            animation.animation = Animation.named("wireframeLoading")
            animation.animationSpeed = 0.8
            animation.alpha = 0.5
            return
        }
    }
    
    func setupView(_ layout: LoaderLayout) {
        switch layout {
        case .icon:
            animation.frame = self.frame
            animation.snp.remakeConstraints { make in
                make.edges.equalToSuperview()
            }
            return
        }
    }
    
    enum LoaderType {
        case content
    }
    
    enum LoaderLayout {
        case icon
    }
}
