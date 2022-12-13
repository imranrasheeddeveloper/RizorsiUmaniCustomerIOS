//
//  LoginViewModel.swift
//  IamHere
//
//  Created by Imran Rasheed on 06/09/2022.
//

import UIKit

struct LoginViewModel {
    let passwordLengthRange = (6, 14) // (minimum length, maximum length)
    let usernameEmptyMessage = "Please Enter Username"
    let passwordEmptyMessage = "Please Enter Password"
    let usernameErrorMessage = "Entered Username is invalid"
    let passwordErrorMessage = "Password length must be in range 6-10 characters."
    func validateInput(_ username: String?, password: String?, completion: (Bool, String?) -> Void) {
        if let username = username {
            if username.isEmpty {
                completion(false, usernameEmptyMessage)
                return
            } else if !username.isValidEmail() {
                completion(false, usernameErrorMessage)
                return
            }
        } else {
            completion(false, usernameEmptyMessage)
            return
        }
        if let password = password {
            if password.isEmpty {
                completion(false, passwordEmptyMessage)
                return
            } else if !validateTextLength(password, range: passwordLengthRange) {
                completion(false, passwordErrorMessage)
                return
            }
        } else {
            completion(false, passwordEmptyMessage)
            return
        }
        // Validated successfully.
        completion(true, nil)
    }

    private func validateTextLength(_ text: String, range: (Int, Int)) -> Bool {
        return (text.count >= range.0) && (text.count <= range.1)
    }

    func login(_ params: [String: Any], completion: @escaping (Result<UserResponseModel? , Error>) -> Void) {
        print("Input:\(params)")
        APIService.sharedInstance.postRequest(loadinIndicator: false, urlString: Constants.URLs.baseUrl + Endpoint.shared.loginUrl, bodyData: params, completionBlock: {data,err in
            if err != nil{
                completion(.failure(err!))
            }
            do{
              let jsonData = data?.toJSONString1().data(using: .utf8)!
              let decoder = JSONDecoder()
                if let successResponse = try? decoder.decode(UserResponseModel.self, from: jsonData!) {
                    completion(.success(successResponse))
                } else if let responseError = try? decoder.decode(ErrorModel.self, from: jsonData!) {
                    completion(.failure(NSError(domain: responseError.message, code: 200)))
                }
            }

            
        })
    }
    func uploadImage(_ image: Data, completion: @escaping (Result<ImageUpload? , Error>) -> Void) {
        APIService.sharedInstance.uploadImage(loadinIndicator: false, urlString: Constants.URLs.baseUrl + Endpoint.shared.profilePhoto, image: image, completionBlock: {data,err in
            if err != nil{
                completion(.failure(err!))
            }
            do{
              let jsonData = data?.toJSONString1().data(using: .utf8)!
              let decoder = JSONDecoder()
                if let successResponse = try? decoder.decode(ImageUpload.self, from: jsonData!) {
                    completion(.success(successResponse))
                } else if let responseError = try? decoder.decode(ErrorModel.self, from: jsonData!) {
                    completion(.failure(NSError(domain: responseError.message, code: 200)))
                }
            }
        })
    }
}

struct LoginRequestModel {
    var email: String?
    var password: String
    var type: String
    var phoneNumber: String?

    init(email: String, password: String , type: String) {
        self.email = email
        self.password = password
        self.type = type
    }
    init(phoneNumber: String, password: String, type: String) {
        self.phoneNumber = phoneNumber
        self.password = password
        self.type = type
    }

    func getParamsForEmail() -> [String: Any] {
        return ["email": email!, "password": password , "type" : type , "fcm_token" : "123123"]
    }
    
    func getParamsForPhoneNumber() -> [String: Any] {
        return ["phone_number": phoneNumber!, "password": password , "type" : type , "fcm_token" : "123123"]
    }
}

// MARK: - ImageUpload
struct ImageUpload: Codable {
    let success: Bool
    let filePATH, message: String
}


// MARK: - UserResponseModel
struct UserResponseModel: Codable {
    let success: Bool
    let data: UserResponseModelDataClass
    let token, message: String
}

// MARK: - UserResponseModelDataClass
struct UserResponseModelDataClass: Codable {
    let id: Int
    let firstName, lastName, email, password: String
    let phoneNumber, image, fcmToken, role: String
    let stripeCustomerID, createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email, password
        case phoneNumber = "phone_number"
        case image
        case fcmToken = "fcm_token"
        case role
        case stripeCustomerID = "stripe_customerId"
        case createdAt, updatedAt
    }
}
struct ErrorModel: Codable {
    let success: Bool
    let message: String
}
