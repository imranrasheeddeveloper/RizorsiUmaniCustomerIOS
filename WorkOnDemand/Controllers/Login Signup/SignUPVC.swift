//
//  SignUPVC.swift
//  IamHere
//
//  Created by Imran Rasheed on 07/09/2022.
//

import UIKit

class SignUPVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firsNameTF : UITextField!
    @IBOutlet weak var lastNameTF : UITextField!
    @IBOutlet weak var emailTF : UITextField!
    @IBOutlet weak var userNameTF : UITextField!
    @IBOutlet weak var passwordTF : UITextField!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var termsAndPrivacyLabel : UILabel!
    var viewModel = SignUpViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        firsNameTF.textfiledRoundview(13)
        lastNameTF.textfiledRoundview(13)
        emailTF.textfiledRoundview(13)
        userNameTF.textfiledRoundview(13)
        passwordTF.textfiledRoundview(13)
        passwordTF.enablePasswordToggle()
        firsNameTF.delegate = self
        lastNameTF.delegate = self
        userNameTF.delegate = self
        emailTF.delegate = self
        passwordTF.delegate = self
        signupBtn.roundview(13)
        
        termsAndPrivacyLabel.isUserInteractionEnabled = true
        termsAndPrivacyLabel.lineBreakMode = .byWordWrapping
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tappedOnLabel(_:)))
        tapGesture.numberOfTouchesRequired = 1
        termsAndPrivacyLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc func redirectToLogin(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func tappedOnLabel(_ gesture: UITapGestureRecognizer) {
        guard let text = termsAndPrivacyLabel.text else { return }
        let termsRange = (text as NSString).range(of: "Term of Service")
        let priacyRange = (text as NSString).range(of: "Privacy Policy")
        if gesture.didTapAttributedTextInLabel(label: self.termsAndPrivacyLabel, inRange: termsRange) {
            print("Term of Service")
        } else if gesture.didTapAttributedTextInLabel(label: self.termsAndPrivacyLabel, inRange: priacyRange) {
          print("Privacy Policy")
        }
    }
    
    @IBAction func signupAction(_ sender : UIButton){
        self.view.endEditing(true)
        let signupModel = SignUpModel.init(firstName: firsNameTF.text, lastName: lastNameTF.text, email: emailTF.text, username: userNameTF.text, password: passwordTF.text)
        viewModel.validateInput(signupModel) { (success, errorMessage) in
            if success {
                self.performAPICall()
            } else {
                self.showAlert("Error!", message: errorMessage!, actions: ["Ok"]) { (title) in
                    print("Action title: \(title)")
                }
            }
        }
        
    }
    @IBAction func backButtonAction(_ sender : UIButton){
        redirectToLogin()
    }
    
        private func performAPICall() {
            let requestModel = SignUpRequestModel(firsNameTF.text!, lastName: lastNameTF.text!, email: emailTF.text!, username: userNameTF.text!, password: passwordTF.text!)
                viewModel.signUp(requestModel) { (responseModel , error) in
                    if error == nil {
                    guard let responseModel = responseModel else {
                            return
                        }
                        if responseModel.success {
                            UserDefaults.standard.save(customObject: responseModel, inKey: "UserProfile")
                           // RedirectionHelper.redirectToDashboard()
                            self.showAlert("Success", message: responseModel.message, actions: ["Done"]) { _ in
                                print(responseModel.message)
                            }
                        } else {
                            print(error ?? "No error message")
                        }
                    }
            }
        }
    }
    
    
extension SignUPVC {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firsNameTF {
            lastNameTF.becomeFirstResponder()
        } else if textField == lastNameTF {
            emailTF.becomeFirstResponder()
        } else if textField == emailTF {
            userNameTF.becomeFirstResponder()
        } else if textField == passwordTF {
            signupAction(signupBtn)
        }
        return true
    }
}
