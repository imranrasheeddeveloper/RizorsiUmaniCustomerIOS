//
//  UserViewModel.swift
//  IamHere
//
//  Created by Imran Rasheed on 03/11/2022.
//

import Foundation

struct UserViewModel {
    func updateUser(_ requestModel: UserUpdateRequestModel, completion: @escaping (Result<UserResponseModel? , Error>) -> Void) {
        let params = requestModel.getParams()
        print("Input:\(params)")
        APIService.sharedInstance.postRequest(loadinIndicator: false, urlString: Constants.URLs.baseUrl + Endpoint.shared.updateProfile, bodyData: params, completionBlock: {data,err in
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
}


struct UserUpdateRequestModel {
    var firstName: String
    var lastName: String
    var email: String
    var profile_image: String?
    var username: String
    var token: String
    var id: Int
    

    init(firstName: String, lastName: String,email: String, username:String,id:Int,token : String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.username = username
        self.id = id
        self.token = token
    }
    init(firstName: String, lastName: String,email: String, profile_image: String,username:String,id:Int,token : String) {
        self.firstName = firstName
        self.lastName  = lastName
        self.email = email
        self.username = username
        self.id = id
        self.profile_image = profile_image
        self.token = token
    }

    func getParams() -> [String: Any] {
        return ["firstName": firstName, "lastName": lastName,"email": email, "username": username,"id": id, "profile_image": profile_image ?? "","token": token]
    }
}


// MARK: - Welcome
struct UserModel: Codable {
    let success: Bool
    let data: UserModelDataClass
    let message: String
}

// MARK: - DataClass
struct UserModelDataClass: Codable {
    let id: Int
    let firstName, lastName, username, email: String
    let password, profileImage: String
    let active: Bool
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, firstName, lastName, username, email, password
        case profileImage = "profile_image"
        case active, createdAt, updatedAt
    }
}
