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
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackGround(true, false)

        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func signIn() {
        
        if passwordTextField.text!.count > 0 {
            NCMBUser.logInWithMailAddress(inBackground: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if error != nil{
                    //エラーがあった場合
                    self.showOkAlert(title: "Error", message: error!.localizedDescription)
                } else {
                    //ログイン成功
                    let u = user?.object(forKey:"parameter") as? NCMBObject
                    if u == nil {
                        //初回ログイン
                        user!.acl = nil
                        user?.saveInBackground({ (error) in
                            if(error == nil){
                                let storyboard = UIStoryboard(name: "Questionnaire", bundle: Bundle.main)
                                let rootViewController = storyboard.instantiateViewController(withIdentifier: "QuestionnaireController")
                                self.present(rootViewController, animated: false, completion: nil)
                                
                                //ログイン状態の保持
                                let ud = UserDefaults.standard
                                ud.set(true, forKey: "isLogin")
                                ud.synchronize()
                            }
                            else{
                                self.showOkAlert(title: "Error", message: error!.localizedDescription)
                            }
                        })
                    } else {
                        //２回目以降のログイン
                        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                        let rootViewController = storyboard.instantiateViewController(identifier: "RootTabBarController")
                        self.loadFollowlist()
                        let alertController = UIAlertController(title: "ユーザ情報取得中", message: "しばらくお待ちください。", preferredStyle: .alert)
                        self.present(alertController, animated: true, completion: nil)
                        //画像をダウンロードする。
                        let _ = User(NCMBUser.current())
                        //画像のダウンロードに時間がかかるので、2秒待機
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            alertController.dismiss(animated: true, completion: nil)
                            self.present(rootViewController, animated: true, completion: nil)
                        }
                        
                        //ログイン状態の保持
                        let ud = UserDefaults.standard
                        ud.set(true, forKey: "isLogin")
                        ud.synchronize()
                    }
                }
            }
        }
        
        /*
         if userIdTextField.text!.count > 0 && passwordTextField.text!.count > 0 {
             NCMBUser.logInWithUsername(inBackground: userIdTextField.text!, password: passwordTextField.text!) { (user, error) in
                 if error != nil{
                     //エラーがあった場合
                     self.showOkAlert(title: "Error", message: error!.localizedDescription)
                 } else {
                     //ログイン成功
                     let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                     let rootViewController = storyboard.instantiateViewController(identifier: "RootTabBarController")
                     self.present(rootViewController, animated: true, completion: nil)
                     
 //                    let _ = User(NCMBUser.current())
                     
                     //ログイン状態の保持
                     let ud = UserDefaults.standard
                     ud.set(true, forKey: "isLogin")
                     ud.synchronize()
                 }
             }
         }
         */
        
    }
    
    @IBAction func forgetPassword(){
        //あとで書く
    }


}
