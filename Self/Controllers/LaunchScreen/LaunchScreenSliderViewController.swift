//
//  LaunchSliderViewController.swift
//  Self
//
//  Created by Jamie on 11/04/2019.
//  Copyright © 2019 Jamie De Vivo. All rights reserved.
//

import UIKit

class LaunchScreenSliderViewController: UIViewController {
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.tintColor = UIColor.app.interactive.selectable.selected()
        pageControl.pageIndicatorTintColor = UIColor.app.interactive.selectable.unselected()
        pageControl.currentPageIndicatorTintColor = UIColor.app.interactive.selectable.selected()
        return pageControl
    }()
    
    lazy var onboardingSlides:[LaunchScreenSlideView] = createOnboardingScreens();
}

// MARK: - Overrides
extension LaunchScreenSliderViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        addSubViews()
        setupChildViews()
        setupSlider()
    }
}

// MARK: - Functions
extension LaunchScreenSliderViewController {
    
    func createOnboardingScreens() -> [LaunchScreenSlideView] {
        
        let onboardingSlideOne: LaunchScreenSlideView = {
            let onboardingSlide = LaunchScreenSlideView()
//            onboardingSlide.frame.size.height = scrollView.frame.size.height
            onboardingSlide.image.image = UIImage(named: "home")!.withRenderingMode(.alwaysTemplate)
            onboardingSlide.headline.text = "Personal"
            onboardingSlide.desc.text = "Self is all about you, it's your personal assistant. Every day you'll get a unique message based on what you share and what it learns."
            return onboardingSlide
        }()
        
        let onboardingSlideTwo: LaunchScreenSlideView = {
            let onboardingSlide = LaunchScreenSlideView()
            onboardingSlide.image.image = UIImage(named: "globe")!.withRenderingMode(.alwaysTemplate)
            onboardingSlide.headline.text = "Challenges"
            onboardingSlide.desc.text = "Challenge yourself with positive wellbeing tasks and a community of people all improving their wellbeing."
            return onboardingSlide
        }()
        
        let onboardingSlideThree: LaunchScreenSlideView = {
            let onboardingSlide = LaunchScreenSlideView()
            onboardingSlide.image.image = UIImage(named: "for_you")!.withRenderingMode(.alwaysTemplate)
            onboardingSlide.headline.text = "Journal"
            onboardingSlide.desc.text = "Keep track of your best moments, your mood and gain insights and suggestions based on what affects your wellbeing."
            return onboardingSlide
        }()
        
        return [onboardingSlideOne, onboardingSlideTwo, onboardingSlideThree]
    }

}

// MARK: - Functions
extension LaunchScreenSliderViewController: UIScrollViewDelegate {
    
    func setupSlider() {
        addOnboardingScreensToScrollView(slides: onboardingSlides)
        pageControl.numberOfPages = onboardingSlides.count
        pageControl.currentPage = 0
    }
    
    func addOnboardingScreensToScrollView(slides : [LaunchScreenSlideView]) {
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: scrollView.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}


extension LaunchScreenSliderViewController: ViewBuilding {
    func addSubViews() {
        view.addSubview(scrollView)
        view.addSubview(pageControl)
        view.bringSubviewToFront(pageControl)
    }
    
    func setupChildViews() {
        scrollView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(pageControl.snp.top).offset(10)
        }
        pageControl.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-25)
            make.centerX.equalToSuperview()
            make.height.equalTo(10)
        }
    }
}
