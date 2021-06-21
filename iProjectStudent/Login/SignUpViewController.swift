//
//  SignUpViewController.swift
//  iProjectStudent
//
//  Created by Kaori Nakamura on 2/20/21.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB

class SignUpViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackGround(true, false)
        emailTextField.delegate = self
    }
    @IBAction func signUp() {
        if(emailTextField.text!.count == 0){
            showOkAlert(title: "注意", message: "メールアドレスが入力されていません。")
        }
        else{
            var error: NSError? = nil
            let mail = emailTextField.text!
            NCMBUser.requestAuthenticationMail(mail, error: &error)
            if(error == nil){
                self.showOkDismissAlert(title: "報告", message: "本人確認用のメールアドレスを送信いたします。しばらくお待ちください。")
            }
            else{
                showOkAlert(title: "Error", message: error!.localizedDescription)
            }
        }
    }
    func showOkDismissAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertOkAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alertController.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(alertOkAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
