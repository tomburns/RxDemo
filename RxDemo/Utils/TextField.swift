//
//  TextField.swift
//  RxDemo
//
//  Created by Jean-Michel Barbieri on 5/12/18.
//  Copyright © 2018 Jean-Michel Barbieri. All rights reserved.
//

import UIKit

extension UITextField {
    public class func loginTXF() -> UIKit.UITextField {
        let textfield = UITextField()
        textfield.layer.sublayerTransform = CATransform3DMakeTranslation(16, 0, 0)
        textfield.font = UIFont.systemFont(ofSize: 17)
        textfield.borderStyle = .line
        textfield.textColor = UIColor.black
        textfield.layer.borderColor = UIColor.lightGray.cgColor
        textfield.layer.borderWidth = 1.0
        textfield.autocapitalizationType = .none
        textfield.autocorrectionType = .no
        textfield.backgroundColor = UIColor(white: 1, alpha: 0.8)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        
        return textfield
    }
}
