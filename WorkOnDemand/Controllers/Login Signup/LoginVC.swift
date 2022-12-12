//
//  LoginVC.swift
//  IamHere
//
//  Created by Imran Rasheed on 06/09/2022.
//

import UIKit

class LoginVC: UIViewController, SocialManagerDelegate {
    
    @IBOutlet weak var loginBtn : UIButton!
    @IBOutlet weak var signupLbl: UILabel!
    @IBOutlet weak var emailTF : UITextField!
    @IBOutlet weak var passwordTF : UITextField!
    var viewModel = LoginViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        emailTF.delegate = self
        passwordTF.delegate = self
        loginBtn.configure(13)
        emailTF.textfiledRoundview(13)
        passwordTF.textfiledRoundview(13)
        passwordTF.isSecureTextEntry = true
        passwordTF.enablePasswordToggle()
        let tap = UITapGestureRecognizer(target: self, action: #selector(redirectToSignup))
        signupLbl.addGestureRecognizer(tap)
        
    }
    
    @objc func redirectToSignup(){
        let controller = storyboard?.instantiateViewController(identifier: "SignupVC")
        self.navigationController?.pushViewController(controller!, animated: true)
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        self.view.endEditing(true)
        viewModel.validateInput(emailTF.text, password: passwordTF.text) { [weak self] (success, message) in
            if success {
                self?.performAPICall()
            } else {
                self?.showAlert("Error!", message: message!, actions: ["Ok"]) { (actionTitle) in
                    print(actionTitle)
                }
            }
        }
    }
    @IBAction func facebookSignInAction(_ sender: Any) {
        SocialManager.shared.loginWithSocialType(socialType: .faceBook, delegate: self)
    }
    
    func didLoginSuccessFully(socialType: SocialLoginType) {
        ///
    }
    
    func showGoogleSignInPresentingViewController() {
        /////
    }
    func performAPICall() {
        
        let requestModel = LoginRequestModel(email: emailTF.text!, password: passwordTF.text!)
        viewModel.login(requestModel) { result in
            switch result {
            case .success(let data):
                guard let responseModel = data else {return}
                if responseModel.success {
                    UserDefaults.standard.save(customObject: responseModel, inKey: "UserProfile")
                    //RedirectionHelper.redirectToDashboard()
                    //let obj = UserDefaults.standard.retrieve(object: UpdateProfile.self, fromKey: "YourKey")
                 self.showAlert("Success", message: responseModel.message, actions: ["Done"]) { _ in
                  print(responseModel.message)
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
}
