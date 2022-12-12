//
//  SignUpViewModel.swift
//  IamHere
//
//  Created by Imran Rasheed on 06/09/2022.
//

import UIKit

typealias ValidationCompletion = (Bool, String?) -> Void

struct SignUpViewModel {

    let firstNameLengthRange = (6, 24) // (minimum length, maximum length)
    let firstNameEmptyMessage = "Please Enter first name"
    let lastNameLengthRange = (6, 24) // (minimum length, maximum length)
    let lastNameEmptyMessage = "Please Enter last name"
    let usernameEmptyMessage = "Please Enter Username"
    let usernameErrorMessage = "Entered Username is invalid"
    let emailEmptyMessage = "Please Enter Email"
    let emailErrorMessage = "Please Enter Valid Email"
    let passwordEmptyMessage = "Please Enter Password"
    let passwordLengthRange = (6, 14) // (minimum length, maximum length)
    let passwordErrorMessage = "Password length must be in range 6-14 characters."
    
    
    

    func validateInput(_ signupModel: SignUpModel, completion: ValidationCompletion) {

        guard self.validateFirstName(signupModel, completion: completion)else { return }
        guard self.validateLastName(signupModel, completion: completion) else { return }
        guard self.validateUsername(signupModel, completion: completion) else { return }
        guard self.validateEmail(signupModel, completion: completion) else { return }
        guard self.validatePassword(signupModel, completion: completion) else { return }
        
        completion(true, nil)
    }
    
    
    private func validateFirstName(_ signupModel: SignUpModel, completion: ValidationCompletion) -> Bool{
        if let fname = signupModel.firstName {
            if fname.isEmpty {
                completion(false, firstNameEmptyMessage)
                return false
            }
        } else {
            completion(false, firstNameEmptyMessage)
            return false
        }
        return true
    }
    
    private func validateLastName(_ signupModel: SignUpModel, completion: ValidationCompletion) -> Bool{
        if let fname = signupModel.lastName {
            if fname.isEmpty {
                completion(false, lastNameEmptyMessage)
                return false
            }
        } else {
            completion(false, lastNameEmptyMessage)
            return false
        }
        return true
    }
    private func validateEmail(_ signupModel: SignUpModel, completion: ValidationCompletion) -> Bool{
        if let username = signupModel.email {
            if username.isEmpty {
                completion(false, emailEmptyMessage)
                return false
            } else if !username.isValidEmail() {
                completion(false, emailErrorMessage)
                return false
            }
        } else {
            completion(false, emailEmptyMessage)
            return false
        }
        return true
    }
    
    
    private func validateUsername(_ signupModel: SignUpModel, completion: ValidationCompletion) -> Bool {
        if let username = signupModel.username {
            if username.isEmpty {
                completion(false, usernameEmptyMessage)
                return false
            }
        } else {
            completion(false, usernameEmptyMessage)
            return false
        }
        return true
    }
    
    
    private func validatePassword(_ signupModel: SignUpModel, completion: ValidationCompletion) -> Bool {
        guard let password = signupModel.password else {
            completion(false, passwordEmptyMessage)
            return false
        }
        if password.isEmpty {
            completion(false, passwordEmptyMessage)
            return false
        } else if !validateTextLength(password, range: passwordLengthRange) {
            completion(false, passwordErrorMessage)
            return false
        }
        return true
    }

    private func validateTextLength(_ text: String, range: (Int, Int)) -> Bool {
        return (text.count >= range.0) && (text.count <= range.1)
    }

    func signUp(_ request: SignUpRequestModel, completion: @escaping (UserResponseModel?,Error?) -> Void) {
        
        let params = request.getParams()
        print("Signup Input:\(params)")
        APIService.sharedInstance.postRequest(loadinIndicator: false, urlString: Constants.URLs.baseUrl + Endpoint.shared.registerUrl, bodyData: params, completionBlock: {data,err  in
            if err != nil{
                completion(nil, err)
            }
            do{
              let jsonData = data?.toJSONString1().data(using: .utf8)!
              let decoder = JSONDecoder()
              let obj = try decoder.decode(UserResponseModel.self, from: jsonData!)
             completion(obj, nil)
            }catch{
                completion(nil, err)
          }
        })
    }
}

struct SignUpRequestModel {
    var firstName: String
    var lastName: String
    var email: String
    var username: String
    var password: String
    init(_ firstName: String, lastName: String, email: String, username: String , password : String) {
        self.firstName = firstName
        self.lastName = lastName
        self.password = password
        self.email = email
        self.username = username
    }

    func getParams() -> [String: Any] {
        return ["firstName": firstName, "lastName": lastName, "username": username, "password": password , "email" : email]
    }
}


struct SignUpModel {
    var firstName: String?
    var lastName: String?
    var email: String?
    var username: String?
    var password: String?
}

struct UserResponseModel: Codable {
    let success: Bool
    let data: UserResponseModelDataClass
    let message: String
}


struct UserResponseModelDataClass: Codable {
    let user: User?
    let token: String?
}


struct User: Codable {
    let id: Int
    let firstName, lastName, username, email: String?
    let password: String?
    let profileImage: String?
    let active: Bool?
    let createdAt, updatedAt: String?
    enum CodingKeys: String, CodingKey {
        case id, firstName, lastName, username, email, password
        case profileImage = "profile_image"
        case active, createdAt, updatedAt
    }
}
struct ErrorModel: Codable {
    let success: Bool
    let message: String
}

