//
//  SignUpViewController.swift
//  iProjectStudent
//
//  Created by Kaori Nakamura on 2/4/21.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB

class SignUp2ViewController: UIViewController,UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var userIdTextField: UITextField!
    @IBOutlet var userIdFuriganaTextField: UITextField!
    @IBOutlet var schoolTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var parentemailTextField: UITextField!
    @IBOutlet var gradeTextField: UITextField!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmTextField: UITextField!
    
    var selected: String?
    
    let dataList = ["文理選択","文系","理系","その他"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userIdTextField.delegate = self
        userIdFuriganaTextField.delegate = self
        schoolTextField.delegate = self
        emailTextField.delegate = self
        parentemailTextField.delegate = self
        gradeTextField.delegate = self
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
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return dataList[row]
    }
    
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row != 0 {
            selected = dataList[row]
        } else {
            selected = nil
        }
    }
    
    @IBAction func signUp() {
        
        if passwordTextField.text == confirmTextField.text {
//            userNameやmailAddressが空白か確認をするコードの追加をする。
            if(userIdTextField.text!.count * emailTextField.text!.count == 0){
                showOkAlert(title: "注意", message: "ユーザー名かメールアドレスが入力されていません。")
            }
            else{
                if selected != nil {
                    let user = NCMBUser()
                    user.userName = userIdTextField.text!
                    user.mailAddress = emailTextField.text!
                    user.password = passwordTextField.text!
                    
                    let object = NCMBObject(className: "StudentParameter")
                    object?.setObject(user, forKey: "user")
                    //クラス間で紐付け
                    object?.setObject(selected!, forKey: "selection")
                    object?.setObject(parentemailTextField.text!, forKey: "parentEmailAdress")
                    object?.setObject(gradeTextField.text!, forKey: "grade")
                    object?.setObject(schoolTextField.text!, forKey: "SchoolName")
//                    object?.setObject(gradeTextField.text!, forKey: "grade")
//                    object?.setObject(parentemailTextField.text!, forKey: "parentEmailAdress")
                    
                    user.signUpInBackground { [self] (error) in
                        if error != nil{
                            //エラーがあった場合
                            self.showOkAlert(title: "エラー", message: error!.localizedDescription)
                        } else {
                            //登録成功
                            print("登録成功",user.object(forKey: "mailAddress"))
                            print("emailTextField.text",emailTextField.text)
                            object?.saveInBackground({ (error) in
                                if error != nil {
                                    self.showOkAlert(title: "エラー", message: error!.localizedDescription)
                                } else {
                                    
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
                                    user.setObject(self.userIdFuriganaTextField.text, forKey: "furigana")
                                    user.setObject(false, forKey: "isTeacher")
                                    user.setObject(object!, forKey: "parameter")
                                    user.setObject(nil, forKey: "peerId")
                                    user.setObject(true, forKey: "isActive")
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
                            })
                            
                        }
                    }
                } else {
                    showOkAlert(title: "エラー", message: "文理選択がされていません")
                }
            }
        } else {
            showOkAlert(title: "エラー", message: "パスワードが一致していません")
        }

    }

}
