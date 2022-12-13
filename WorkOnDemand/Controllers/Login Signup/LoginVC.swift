//
//  LoginVC.swift
//  IamHere
//
//  Created by Imran Rasheed on 06/09/2022.
//

import UIKit

enum LoginType{
case email
case phone
}

class LoginVC: UIViewController, SocialManagerDelegate {
    
    // MARK: - Otlets
    @IBOutlet weak var loginBtn : UIButton!
    @IBOutlet weak var signupLbl: UILabel!
    @IBOutlet weak var emailTF : UITextField!
    @IBOutlet weak var passwordTF : UITextField!
    @IBOutlet weak var emailBtn : UIButton!
    @IBOutlet weak var phoneBtn : UIButton!
    
    @IBOutlet weak var emailOrPhone: UILabel!
    // MARK: - Variables
    
    var viewModel = LoginViewModel()
    var requestModel : LoginRequestModel?
    var loginType : LoginType = .email
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setupView()
        
    }
    
    // MARK: - Actions
    
    @IBAction func loginAction(_ sender: UIButton) {
        self.view.endEditing(true)
        switch loginType{
        case .email:
            viewModel.validateInput(emailTF.text, password: passwordTF.text) { [weak self] (success, message) in
                if success {
                    self?.performAPICall(email: emailTF.text, phoneNumber: nil, password: passwordTF.text!)
                } else {
                    self?.showAlert("Error!", message: message!, actions: ["Ok"]) { (actionTitle) in
                        print(actionTitle)
                    }
                }
            }
        case .phone:
            viewModel.validateInput(emailTF.text, password: passwordTF.text) { [weak self] (success, message) in
                if success {
                    self?.performAPICall(email: nil, phoneNumber: emailTF.text, password: passwordTF.text!)
                } else {
                    self?.showAlert("Error!", message: message!, actions: ["Ok"]) { (actionTitle) in
                        print(actionTitle)
                    }
                }
            }
        }
        
    }
    @IBAction func facebookSignInAction(_ sender: UIButton) {
        SocialManager.shared.loginWithSocialType(socialType: .faceBook, delegate: self)
    }
    
    @IBAction func loginWithemail(_ sender: UIButton) {
        loginType = .email
        
        emailBtn.backgroundColor = .primaryColor
        emailBtn.setTitleColor(.white, for: .normal)
        
        phoneBtn.backgroundColor = .white
        phoneBtn.setTitleColor(.black, for: .normal)
        
        emailOrPhone.text = "Email"
        emailTF.placeholder = "Enter your Email"
        
    }
    @IBAction func loginWithPhoneNumber(_ sender: UIButton) {
        
        loginType = .phone
        emailBtn.backgroundColor = .white
        emailBtn.setTitleColor(.black, for: .normal)
        phoneBtn.backgroundColor = .primaryColor
        phoneBtn.setTitleColor(.white, for: .normal)
        emailOrPhone.text = "Phone Number"
        emailTF.placeholder = "Enter Your Phone Number"
    }
    
    
    // MARK: - Helper Functions
    
    
    func setupView() {
        emailTF.delegate = self
        passwordTF.delegate = self
        loginBtn.configure(13)
        emailTF.textfiledRoundview(13)
        passwordTF.textfiledRoundview(13)
        passwordTF.isSecureTextEntry = true
        passwordTF.enablePasswordToggle()
        let tap = UITapGestureRecognizer(target: self, action: #selector(redirectToSignup))
        signupLbl.addGestureRecognizer(tap)
        emailBtn.roundview(13)
        emailTF.text = "test@gmail.com"
        passwordTF.text = "12345678"
        phoneBtn.roundview(13)
    }
    
    @objc func redirectToSignup(){
        let controller = storyboard?.instantiateViewController(identifier: "SignupVC")
        self.navigationController?.pushViewController(controller!, animated: true)
    }
    
    
    func performAPICall(email: String? , phoneNumber: String? , password: String) {
        var params : [String: Any]?
        if let email = email{
            requestModel = LoginRequestModel(email: email, password: password, type: "indvidual")
            params = requestModel?.getParamsForEmail()
        }
        if let phoneNumber = phoneNumber{
            requestModel = LoginRequestModel(phoneNumber: phoneNumber, password: password, type: "indvidual")
            params = requestModel?.getParamsForPhoneNumber()
        }
        guard let params = params else { return  }
        viewModel.login(params) { result in
            switch result {
            case .success(let data):
                guard let responseModel = data else {return}
                if responseModel.success {
                    UserDefaults.standard.save(customObject: responseModel, inKey: "UserProfile")
                 self.showAlert("Success", message: responseModel.message, actions: ["Done"]) { _ in
                     RedirectionHelper.redirectToDashboard()
                   }
                }
            case .failure(let error):
                self.showAlert("Success", message: error.localizedDescription, actions: ["Done"]) { _ in
                  }
            }
        }
        
    }
}
extension LoginVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTF {
            passwordTF.becomeFirstResponder()
        }
        else if textField == passwordTF {
            self.loginAction(loginBtn)
        }
        return true
    }
    
    func didLoginSuccessFully(socialType: SocialLoginType) {
        ///
    }
    
    func showGoogleSignInPresentingViewController() {
        /////
    }
}
