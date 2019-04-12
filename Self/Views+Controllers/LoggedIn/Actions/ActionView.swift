//
//  ActionView.swift
//  Self
//
//  Created by Jamie on 06/04/2019.
//  Copyright © 2019 Jamie De Vivo. All rights reserved.
//

import UIKit
import SnapKit

class ActionView: UIView {
    
    lazy var actionCardTagsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .trailing
        return stack
    }()
    lazy var actionCardTagButton: UIButton = {
        let button = UIButton()
        button.setTitle("Be Active", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12.0, weight: .ultraLight)
        button.setTitleColor(UIColor.app.button.tag.text(), for: .normal)
        button.contentEdgeInsets =  UIEdgeInsets(top: 6,left: 15,bottom: 6,right: 15)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        button.layer.cornerRadius = 15
        button.clipsToBounds = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.1
        button.layer.shadowRadius = 1
        button.layer.shadowOffset = CGSize(width: 0,height: 1.5)
        return button
    }()
    lazy var actionCardTagButtonTwo: UIButton = {
        let button = UIButton()
        button.setTitle("Outdoors", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12.0, weight: .ultraLight)
        button.setTitleColor(UIColor.app.button.tag.text(), for: .normal)
        button.contentEdgeInsets =  UIEdgeInsets(top: 6,left: 15,bottom: 6,right: 15)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        button.layer.cornerRadius = 15
        button.clipsToBounds = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.1
        button.layer.shadowRadius = 1
        button.layer.shadowOffset = CGSize(width: 0,height: 1.5)
        return button
    }()
    lazy var actionCardTagButtonThree: UIButton = {
        let button = UIButton()
        button.setTitle("10 mins", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12.0, weight: .ultraLight)
        button.setTitleColor(UIColor.app.button.tag.text(), for: .normal)
        button.contentEdgeInsets =  UIEdgeInsets(top: 6,left: 15,bottom: 6,right: 15)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        button.layer.cornerRadius = 15
        button.clipsToBounds = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.1
        button.layer.shadowRadius = 1
        button.layer.shadowOffset = CGSize(width: 0,height: 1.5)
        return button
    }()
    lazy var actionCardTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Go for a walk"
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.textColor = UIColor.app.text.solidText()
        return label
    }()
    lazy var actionCardDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .light)
        label.text = "Walking is good for you."
        label.textColor = UIColor.app.text.solidText()
        label.numberOfLines = 0
        return label
    }()
    lazy var actionCardStartButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start", for: .normal)
        button.setTitleColor(UIColor.app.text.solidText(), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    internal func setupView() {
        backgroundColor = .white
        addSubViews()
        addConstraints()
        layer.cornerRadius = 30
        backgroundColor = UIColor.app.button.tag.fill()
        clipsToBounds = true
    }
    
}

extension ActionView {
    convenience init(actionCardTitleLabel: String, actionCardDescriptionLabel:String) {
        self.init()
        self.actionCardTitleLabel.text = actionCardTitleLabel
        self.actionCardDescriptionLabel.text = actionCardDescriptionLabel
    }
}
extension ActionView: ViewBuilding {
    func addSubViews() {
        self.addSubview(actionCardTagsStack)
            actionCardTagsStack.addArrangedSubview(actionCardTagButton)
            actionCardTagsStack.addArrangedSubview(actionCardTagButtonTwo)
            actionCardTagsStack.addArrangedSubview(actionCardTagButtonThree)
        self.addSubview(actionCardTitleLabel)
        self.addSubview(actionCardDescriptionLabel)
        self.addSubview(actionCardStartButton)
    }
    
    func addConstraints() {
        actionCardTagsStack.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().inset(10)
            make.height.equalTo(30)
        }
        actionCardTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(actionCardTagsStack.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        actionCardDescriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(actionCardTitleLabel.snp.bottom).offset(10)
            make.width.equalTo(actionCardTitleLabel.snp.width)
            make.left.equalToSuperview().offset(20)
        }
        actionCardStartButton.snp.makeConstraints { (make) in
            make.top.equalTo(actionCardTagsStack.snp.bottom)
            make.left.equalTo(actionCardTitleLabel.snp.right)
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.centerY.equalToSuperview()
        }
    }
}
