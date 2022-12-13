//
//  File.swift
//  IamHere
//
//  Created by Imran Rasheed on 06/09/2022.
//

import Foundation
import UIKit
enum SocialLoginType: Int {
    case google = 0
    case faceBook
    case apple
}

var isOnTabBar : Bool = false

struct Constants {
    struct Segue {
        static let verifyOTP = "segueToVerifyOtp"
        static let resetPassword = "segueToResetPassword"
    }

    struct Keys {
        static let environment = "currentEnvironment"
    }

    struct URLs {
        static let baseUrl = "http://34.203.72.68:4000"
        static let sproductionUrl = "http://54.144.70.55:3000"
    }

    struct Message {
        static let invalidUrl = "Invalid Url"
        static let logoutWarning = "Are you sure you want to logout?"
    }

    struct GoogleSignIn {
        static let clientId = "750192727959-49ilo64c4cc9fbigm6em7pe5aa5ghmld.apps.googleusercontent.com"
    }
}
func dateFormat(date: String) -> String {

     let olDateFormatter = DateFormatter()
     olDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sss'Z'"

     let oldDate = olDateFormatter.date(from: date)

     let convertDateFormatter = DateFormatter()
     convertDateFormatter.dateFormat = "dd/MM/YYY h:mm a"

     return convertDateFormatter.string(from: oldDate!)
}

func dateFormat(date: Date) -> String {

     let convertDateFormatter = DateFormatter()
     convertDateFormatter.dateFormat = "dd/MM/YYY h:mm a"
     return convertDateFormatter.string(from: date)
}
