//
//  Data+Helpers.swift
//  IamHere
//
//  Created by Imran Rasheed on 03/11/2022.
//

import Foundation

extension Data {
    mutating func append(_ string: String) {
        self.append(string.data(using: .utf8, allowLossyConversion: true)!)
    }
}
