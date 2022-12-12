//
//  SetImage.swift
//  IamHere
//
//  Created by Imran Rasheed on 13/09/2022.
//

import Foundation
import UIKit
import Kingfisher

class KingFisherHelper  {
   static func setImage(url : String , imageView :UIImageView) {
       let url = URL(string: Constants.URLs.baseUrl+url)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
    }
}

