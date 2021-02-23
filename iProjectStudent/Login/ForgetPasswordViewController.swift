//
//  ForgetPasswordViewController.swift
//  iProjectStudent
//
//  Created by Kaori Nakamura on 2/22/21.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//
import UIKit
import NCMB

class ForgetPasswordViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var ForgetemailTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ForgetemailTextField.delegate = self
        setBackGround(false, false)

        // Do any additional setup after loading the view.
    }
    @IBAction func signUp() {
        if(ForgetemailTextField.text == ""){
            showOkAlert(title: "注意", message: "メールアドレスを入力してください。")
        }
        else{
            let Forgetemail = ForgetemailTextField.text
            
            NCMBUser.requestPasswordResetForEmail(inBackground: Forgetemail, block: {(error) in
                if (error != nil) {
                    self.showOkAlert(title: "Error", message: error!.localizedDescription);
                } else {
                    self.showOkAlert(title: "報告", message: "メール送信完了")
                }
            })
        }
    }
    
}
