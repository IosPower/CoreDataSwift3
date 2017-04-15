//
//  HelperExtensions.swift
//  CoreDataSwift3
//
//  Created by piyush sinroja on 15/04/17.
//  Copyright © 2017 Piyush. All rights reserved.
//

import UIKit

class HelperExtensions: NSObject {

}

//MARK:- Extension UIButton
extension UIButton {
    func cornerRadius(valueRadius: CGFloat) {
        self.layer.cornerRadius = valueRadius
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.black.cgColor
    }
}

//MARK:- Extension UITextField
extension String {
    func trimming() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
}

//MARK:- Extension UIImageView
extension UIImageView {
    func cornerRadius() {
        self.layer.cornerRadius = self.frame.size.width/2
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = true
    }
}
