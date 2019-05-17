//
//  StoryDetailViewController.swift
//  AppStoreClone
//
//  Created by Phillip Farrugia on 6/18/17.
//  Copyright © 2017 Phill Farrugia. All rights reserved.
//

import UIKit

class StoryDetailViewController: UIViewController {
    
    /// Container
    @IBOutlet private weak var contentContainerView: UIView!
    @IBOutlet private weak var containerLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var containerTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var containerTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var containerBottomConstraint: NSLayoutConstraint!
    
    /// Header Image Height
    @IBOutlet private weak var headerImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var headerImageView: UIImageView!
    
    internal func positionContainer(left: CGFloat, right: CGFloat, top: CGFloat, bottom: CGFloat) {
        containerLeadingConstraint.constant = left
        containerTrailingConstraint.constant = right
        containerTopConstraint.constant = top
        containerBottomConstraint.constant = bottom
        view.layoutIfNeeded()
    }
    
    internal func setHeaderHeight(_ height: CGFloat) {
        headerImageHeightConstraint.constant = height
        view.layoutIfNeeded()
    }
    
    internal func configureRoundedCorners(shouldRound: Bool) {
        headerImageView.layer.cornerRadius = shouldRound ? 14.0 : 0.0
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func closeButtonDidPress(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
//
//
//import UIKit
//import SnapKit
//
//class StoryDetailViewController: UIViewController {
//    
//    /// Container
//    lazy var contentContainerView: UIView = {
//        let view = UIView()
//        view.isUserInteractionEnabled = true
//        return view
//    }()
//    
//    lazy var exitButton: UIButton = {
//        let button = UIButton()
//        let btnImage = UIImage(named:"light-close-button")
//        button.setImage(btnImage, for: .normal)
//        return button
//    }()
//    
//    lazy var title: UILabel = {
//        let label = UILabel()
//        label.text = "The Art of the Impossible"
//        label.textColor = UIColor.white
//        return label
//    }()
//    
//    lazy var scrollView: UIScrollView = {
//        let scrollView = UIScrollView()
//        scrollView.isScrollEnabled = true
//        scrollView.bounces = true
//        scrollView.bouncesZoom = true
//        scrollView.isUserInteractionEnabled = true
//        scrollView.canCancelContentTouches = true
//        scrollView.delaysContentTouches = true
//        return scrollView
//    }()
//    
//    /// Header Image Height
//    lazy var headerImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.layer.cornerRadius = 14.0
//        return imageView
//    }()
//    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
//    
//    func closeButtonDidPress(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
//    }
//    
//    func setupViews() {
//        view.addSubview(contentContainerView)
//        contentContainerView.addSubview(scrollView)
//        scrollView.addSubview(headerImageView)
//        
//        contentContainerView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
//        scrollView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
//        headerImageView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
//    }
//    
//}
