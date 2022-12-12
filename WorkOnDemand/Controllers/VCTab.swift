//
//  VCTab.swift
//  IamHere
//
//  Created by Imran Rasheed on 15/09/2022.
//

import UIKit

class VCTab: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.selectedIndex = 1
//        self.title = "Measure"

        self.delegate = self
    }

    //MARK:-  UITabBarDelegate
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        isOnTabBar = true
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//           super.viewWillAppear(animated)
//           self.navigationItem.leftBarButtonItems = [UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)]
//       }
//
////    //MARK:- UITabBarControllerDelegate
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController)!
//         if selectedIndex == 3{
//            isOnTabBar = true
//        }
//        else if selectedIndex == 2 {
//            self.title = "Setting"
//        } else {
//            //do whatever
//        }
//    }

}
