//
//  ScreenHeaderLabelView.swift
//  Self
//
//  Created by Jamie De Vivo (i7436295) on 09/04/2019.
//  Copyright © 2019 Jamie De Vivo. All rights reserved.
//

import UIKit
import SnapKit

class HeaderLabel: UILabel {
    
    convenience init(_ title:String, _ type: HeaderType) {
        self.init()
        text = title
        setup(type)
    }
    
    func setup(_ type: HeaderType) {
        numberOfLines = 0
        lineBreakMode = .byWordWrapping
        switch type {
            case .screen:
                font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.semibold)
                textColor = UIColor.app.text.solidText()
                return
            case .section:
                font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
                textColor = UIColor.app.text.solidText().withAlphaComponent(0.8)
                return
            case .subheader:
                font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.light)
                textColor = UIColor.app.text.solidText()
                return
            case .centerPageTitle:
                font = UIFont.systemFont(ofSize: 28, weight: UIFont.Weight.black)
                textColor = UIColor.app.text.solidText().withAlphaComponent(0.4)
                textAlignment = NSTextAlignment.center
                setLineSpacing(lineSpacing: 1.2, lineHeightMultiple: 1.2)
            case .centerPageText:
                font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.semibold)
                textColor = UIColor.app.text.solidText()
                textAlignment = NSTextAlignment.center
                setLineSpacing(lineSpacing: 1.2, lineHeightMultiple: 1.2)
        }
    }
    
    enum HeaderType {
        case screen, section, subheader, centerPageTitle, centerPageText
    }
    
    func applyDefaultScreenHeaderConstraints(usingVC vc: UIViewController) {
        self.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(75)
            make.top.equalTo(vc.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
            make.height.lessThanOrEqualTo(50)
        }
    }
}
