//
//  LoadingReusableView.swift
//  IamHere
//
//  Created by Imran Rasheed on 20/10/2022.
//

import Foundation
import UIKit

class LoadingReusableView: UICollectionReusableView {
    let activityIndicator: UIActivityIndicatorView = {
        let av = UIActivityIndicatorView(style: .medium)
        av.hidesWhenStopped = true
        av.translatesAutoresizingMaskIntoConstraints = false
        return av
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setupUI()
    }

    func setupUI() {
        self.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
