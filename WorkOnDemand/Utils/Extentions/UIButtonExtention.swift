//
//  UIButtonExtention.swift
//  IamHere
//
//  Created by Imran Rasheed on 06/09/2022.
//

import UIKit

extension UIButton {
    func configure(_ cornerRadius: CGFloat, borderColor: UIColor) {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = borderColor.cgColor
        self.layer.cornerRadius = cornerRadius
    }
    func configure(_ cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
    }
}
