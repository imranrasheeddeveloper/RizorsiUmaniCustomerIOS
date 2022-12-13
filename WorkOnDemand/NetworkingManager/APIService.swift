//
//  APIService.swift
//  IamHere
//
//  Created by Imran Rasheed on 09/09/2022.
//

import Foundation
import UIKit
import SystemConfiguration
import CoreImage
struct APIService {
    
    typealias WSCompletionBlock = (_ data: NSDictionary? , Error?) ->()
    typealias WSCompletionStringBlock = (_ data: String?) ->()
    public static let sharedInstance = APIService()
    let appDelegate = AppDelegate()
    func getRequest(loadingIndicator : Bool ,urlString:String, isTokenRequierd : Bool = true,completionBlock:@escaping WSCompletionBlock) -> () {
    
            guard let requestUrl = URL(string:urlString) else { return }
            let session = URLSession.shared
            var request = URLRequest(url: requestUrl as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if isTokenRequierd{
            let obj = UserDefaults.standard.retrieve(object: UserResponseModel.self, fromKey: "UserProfile")
            if let obj = UserDefaults.standard.retrieve(object: UserResponseModel.self, fromKey: "UserProfile"){
                    request.setValue( "Bearer \(obj.token)", forHTTPHeaderField: "Authorization")
                 }
            
            
        }
            let task = session.dataTask(with: request) {
                (data, response, error) in
                if let responseError = error{
                    completionBlock([:], error)
                    print("Response error: \(responseError)")
                }
                else
                {
                    do {
                        let dictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                        DispatchQueue.main.async(execute: {
                            completionBlock(dictionary, nil)
                        })
                    }
                    catch let jsonError as NSError{
                        print("JSON error: \(jsonError.localizedDescription)")
                        completionBlock([:], error)
                    }
                }
            }
            task.resume()

        
    }
    
    func postRequest(loadinIndicator :  Bool , isTokenRequierd: Bool = false ,  urlString:String, bodyData:[String : Any],completionBlock:@escaping WSCompletionBlock) -> () {
        
        print("Hitting URL with Post Request : \n \(urlString) \n\n params : \n \(bodyData)")
        _ = try? JSONSerialization.data(withJSONObject: bodyData)
        guard let requestUrl = URL(string:urlString) else { return }
        let session = URLSession.shared
        var request = URLRequest(url: requestUrl as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 90)
        request.httpMethod = "POST"
       if isTokenRequierd{
       if let obj = UserDefaults.standard.retrieve(object: UserResponseModel.self, fromKey: "UserProfile"){
           request.setValue( "Bearer \(obj.token)", forHTTPHeaderField: "Authorization")
        }
    }
        let postString = self.getPostString(params: bodyData)
        request.httpBody = postString.data(using: .utf8)
        
        let task = session.dataTask(with: request) {
            (data, response, error) in
            if let responseError = error{
                completionBlock([:], error)
                print("Response error: \(responseError)")
            }
            
            else
            {
                do {
                    let dictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    print(dictionary)
                    DispatchQueue.main.async(execute: {
                        completionBlock(dictionary , nil)
                    })
                }
                catch let jsonError as NSError{
                    
                    print("JSON error: \(jsonError)")
                    
                    DispatchQueue.main.async(execute: {
                        completionBlock([:],error)
                    })
                }
            }
        }
        task.resume()
        
    }
    
    func uploadImage(loadinIndicator :  Bool , urlString:String, image:Data,completionBlock:@escaping WSCompletionBlock) -> () {
        
        let form = MultipartForm(parts: [
        MultipartForm.Part(name: "a", value: "1"),
        MultipartForm.Part(name: "b", value: "2"),
        MultipartForm.Part(name: "image", data: image , filename: "profile", contentType: "image/png"),
        ])
        guard let requestUrl = URL(string:urlString) else { return }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        let session = URLSession.shared
        request.setValue(form.contentType, forHTTPHeaderField: "Content-Type")
        
        let task = session.uploadTask(with: request, from: form.bodyData) {
            (data, response, error) in
            if let responseError = error{
                completionBlock([:], error)
                print("Response error: \(responseError)")
            }
            
            else
            {
                do {
                    let dictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    print(dictionary)
                    DispatchQueue.main.async(execute: {
                        completionBlock(dictionary , nil)
                    })
                }
                catch let jsonError as NSError{
                    
                    print("JSON error: \(jsonError)")
                    
                    DispatchQueue.main.async(execute: {
                        completionBlock([:],error)
                    })
                }
            }
        }
        task.resume()
        
    }
    
    func getPostString(params:[String:Any]) -> String
    {
        var data = [String]()
        for(key, value) in params
        {
            data.append(key + "=\(value)")
        }
        return data.map { String($0) }.joined(separator: "&")
    }
    
}
