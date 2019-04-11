//
//  ScreenHeaderLabelView.swift
//  Self
//
//  Created by Jamie De Vivo (i7436295) on 09/04/2019.
//  Copyright © 2019 Jamie De Vivo. All rights reserved.
//

import UIKit

class ScreenHeaderLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubclass()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubclass()
    }
}

extension ScreenHeaderLabel {
    convenience init(title:String) {
        self.init()
        text = title
    }
    
    func setupSubclass() {
        text = "Placeholder"
        font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        textColor = UIColor.app.text.solidText()
    }
}
