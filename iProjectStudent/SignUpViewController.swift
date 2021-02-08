//
//  SignUpViewController.swift
//  iProjectStudent
//
//  Created by Kaori Nakamura on 2/4/21.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB

class SignUpViewController: UIViewController,UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var userIdTextField: UITextField!
    @IBOutlet var schoolTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmTextField: UITextField!
    
    var selected: String?
    
    let dataList = ["文理選択","文系","理系","その他"]

    override func viewDidLoad() {
        super.viewDidLoad()
        

        userIdTextField.delegate = self
        schoolTextField.delegate = self
        emailTextField.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
        passwordTextField.delegate = self
        confirmTextField.delegate = self
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // UIPickerViewの列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // UIPickerViewの行数、リストの数
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return dataList.count
    }
    
    // UIPickerViewの最初の表示
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        return dataList[row]
    }
    
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        if row != 0 {
            selected = dataList[row]
        } else {
            selected = nil
        }
    }
    

    
    @IBAction func signUp() {
        let user = NCMBUser()
        user.userName = userIdTextField.text!
        user.mailAddress = emailTextField.text!
        
        if passwordTextField.text == confirmTextField.text {
            user.password = passwordTextField.text!
            user.setObject(false, forKey: "isTeacher")
            if selected != nil {
                let object = NCMBObject(className: "StudentParameter")
                object?.setObject(user, forKey: "user")
                //クラス間で紐付け
                object?.setObject(selected!, forKey: "selection")
                object?.setObject(schoolTextField.text!, forKey: "SchoolName")
                user.signUpInBackground { (error) in
                    if error != nil{
                        //エラーがあった場合
                        self.showOkAlert(title: "エラー", message: error!.localizedDescription)
                        print(error!.localizedDescription)
                    } else {
                        //登録成功
                        object?.saveInBackground({ (error) in
                            if error != nil {
                                self.showOkAlert(title: "エラー", message: error!.localizedDescription)
                            } else {
                                //ACLオブジェクトを作成
                                let acl = NCMBACL()
                                //読み込み・検索を全開放
                                acl.setPublicReadAccess(true)
                                acl.setPublicWriteAccess(false)
                                acl.setReadAccess(true, for: user)
                                acl.setWriteAccess(true, for: user)
                                user.acl = acl
                                
                                user.setObject(object!, forKey: "parameter")
                                user.setObject(nil, forKey: "peerId")
                                user.setObject(true, forKey: "isActive")
                                user.saveInBackground { (error) in
                                    if error != nil {
                                        self.showOkAlert(title: "エラー", message: error!.localizedDescription)
                                    }
                                }
                                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                                let rootViewController = storyboard.instantiateViewController(identifier: "RootTabBarController")
                                
                                UIApplication.shared.keyWindow?.rootViewController = rootViewController
                                
                                //ログイン状態の保持
                                let ud = UserDefaults.standard
                                ud.set(true, forKey: "isLogin")
                                ud.synchronize()
                            }
                        })

                    }
                }
            } else {
                showOkAlert(title: "エラー", message: "文理選択がされていません")
            }
            
        } else {
            showOkAlert(title: "エラー", message: "パスワードが一致していません")
        }

    }

}
