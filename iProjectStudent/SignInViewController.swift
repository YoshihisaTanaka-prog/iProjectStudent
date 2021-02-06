//
//  SignInViewController.swift
//  iProjectStudent
//
//  Created by Kaori Nakamura on 2/3/21.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var userIdTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        userIdTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func signIn() {
        
        if userIdTextField.text!.count > 0 && passwordTextField.text!.count > 0 {
            NCMBUser.logInWithUsername(inBackground: userIdTextField.text!, password: passwordTextField.text!) { (user, error) in
                if error != nil{
                    //エラーがあった場合
                    print(error)
                } else {
                    //登録成功
                }
            }
        }
        
    }
    
    @IBAction func forgetPassword(){
        //あとで書く
    }


}
