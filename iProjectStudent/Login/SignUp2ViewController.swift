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
        
        setBackGround(true, true)
        
        
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
            if(emailTextField.text!.count == 0){
                showOkAlert(title: "注意", message: "ユーザー名かメールアドレスが入力されていません。")
            }
            else{
                if selected != nil {
                    var error: NSError? = nil
                    let mail = emailTextField.text!
                    NCMBUser.requestAuthenticationMail(mail, error: &error)
                    if(error == nil){
                        self.showOkDismissAlert(title: "報告", message: "本人確認用のメールアドレスを送信いたします。しばらくお待ちください。")
                    }
                    else{
                        showOkAlert(title: "Error", message: error!.localizedDescription)
                    }
                } else {
                    showOkAlert(title: "エラー", message: "文理選択がされていません")
                }
            }
        } else {
            showOkAlert(title: "エラー", message: "パスワードが一致していません")
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
