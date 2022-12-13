//
//  UIViewControllerExtention.swift
//  IamHere
//
//  Created by Imran Rasheed on 06/09/2022.
//

import UIKit

extension UIViewController {
    func showAlert(_ title: String, message: String, actions: [String], completion: @escaping ((String) -> Void)) {
        let controller = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        for title in actions {
            controller.addAction(UIAlertAction.init(title: title, style: .default, handler: { _ in
                completion(title)
            }))
        }
        DispatchQueue.main.async {
            self.present(controller, animated: true, completion: nil)
        }
        
    }
}
extension NSDictionary{
   func toJSONString1() -> String{
    if JSONSerialization.isValidJSONObject(self) {
      do{
        let data = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions(rawValue: 0))
        if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
          return string as String
        }
      }catch {
        print("error")
      }
    }
    return ""
  }
}
