//
//  LaunchNavigationController.swift
//  Self
//
//  Created by Jamie De Vivo (i7436295) on 09/04/2019.
//  Copyright © 2019 Jamie De Vivo. All rights reserved.
//

import UIKit

class LaunchNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
            title = "Self"
            view.backgroundColor = UIColor.app.background()
            navigationBar.barTintColor = UIColor.app.solidText()
            navigationBar.tintColor = UIColor.app.solidText()
            navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            navigationBar.shadowImage = UIImage()
            navigationBar.isTranslucent = true
            viewControllers = [LaunchViewController()]
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
