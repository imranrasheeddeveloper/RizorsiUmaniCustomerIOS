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

    func login(_ requestModel: LoginRequestModel, completion: @escaping (Result<UserResponseModel? , Error>) -> Void) {
        let params = requestModel.getParams()
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
    var email: String
    var password: String

    init(email: String, password: String) {
        self.email = email
        self.password = password
    }

    func getParams() -> [String: Any] {
        return ["email": email, "password": password]
    }
}

// MARK: - ImageUpload
struct ImageUpload: Codable {
    let success: Bool
    let filePATH, message: String
}
