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
            
            /*
             
             let user = NCMBUser()
             user.mailAddress = emailTextField.text!
             user.signUpInBackground { [self] (error) in
             if error != nil{
             //エラーがあった場合
             self.showOkAlert(title: "エラー", message: error!.localizedDescription)
             } else {
             //登録成功
             
             let groupACL = NCMBACL()
             let currentUser = NCMBUser.current()
             
             //会員本人（currentUser）の権限
             //for: userは、自分（currentUser）に対してacl情報を書き換える
             groupACL.setReadAccess(true, for: currentUser)
             groupACL.setWriteAccess(true, for: currentUser)
             
             //全てのユーザの権限
             //setPublicReadAccessをtrueにすれば他人の情報を取得可能！
             //基本的にsetPublicWriteAccessをtrueにすると、他人でもユーザ消したり、情報変更できてしまうから注意
             groupACL.setPublicReadAccess(true)
             groupACL.setPublicWriteAccess(false)
             
             //userクラスにこれまで設定してきたACL情報をセット
             user.acl = groupACL
             
             //userデータ(設定したacl情報)を保存する
             
             user.mailAddress = self.emailTextField.text!
             user.saveInBackground { (error) in
             if error != nil {
             self.showOkAlert(title: "エラー", message: error!.localizedDescription)
             }
             }
             let storyboard = UIStoryboard(name: "Questionnaire", bundle: Bundle.main)
             let rootViewController = storyboard.instantiateViewController(identifier: "QuestionnaireController")
             
             UIApplication.shared.keyWindow?.rootViewController = rootViewController
             
             //ログイン状態の保持
             let ud = UserDefaults.standard
             ud.set(true, forKey: "isLogin")
             ud.synchronize()
             }
             }
             */
            
            
            
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
