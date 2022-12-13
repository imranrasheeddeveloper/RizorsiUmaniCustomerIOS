//
//  RedirectionHelper.swift
//  IamHere
//
//  Created by Imran Rasheed on 06/09/2022.
//
import UIKit

struct RedirectionHelper {
    static func redirectToLogin() {
        DispatchQueue.main.async {
            let loginVc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
            UIApplication.shared.currentUIWindow()?.rootViewController = loginVc
            UIApplication.shared.currentUIWindow()?.makeKeyAndVisible()
        }
    }
    static func redirectToDashboard(){
    
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        let rootVC = storyboard.instantiateViewController(identifier: "tabbar")
        UIApplication.shared.currentUIWindow()?.rootViewController = rootVC
        UIApplication.shared.currentUIWindow()?.makeKeyAndVisible()
    }
}
public extension UIApplication {
    func currentUIWindow() -> UIWindow? {
        if #available(iOS 13.0, *) {
            let connectedScenes = UIApplication.shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .compactMap { $0 as? UIWindowScene }
            let window = connectedScenes.first?
                .windows
                .first { $0.isKeyWindow }
            return window
        } else {
            // Fallback on earlier versions
        }
       return nil
        
    }
}
