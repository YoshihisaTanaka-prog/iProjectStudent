//
//  UserPageViewController.swift
//  iProjectStudent
//
//  Created by Kaori Nakamura on 2/10/21.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB
import NYXImagesKit

class UserPageViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet private var userImageView: UIImageView!
    
    @IBOutlet private var userIdTextField: UITextField!
    @IBOutlet private var userIdFuriganaTextField: UITextField!
    @IBOutlet private var schoolTextField: UITextField!
    @IBOutlet private var gradeTextField: UITextField!
    @IBOutlet private var choiceTextField: UITextField!
    @IBOutlet private var selectionTextField: UITextField!
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var parentsEmailTextField: UITextField!
    @IBOutlet private var introductionTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2.0
        userImageView.layer.masksToBounds = true
        
        setBackGround(true, true)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2.0
        userImageView.layer.masksToBounds = true
        
        userIdTextField.delegate = self
        userIdFuriganaTextField.delegate = self
        schoolTextField.delegate = self
        gradeTextField.delegate = self
        choiceTextField.delegate = self
        emailTextField.delegate = self
        parentsEmailTextField.delegate = self
        introductionTextView.delegate = self
        
        userIdTextField.text = currentUserG.userName
        emailTextField.text = currentUserG.mailAddress
        userIdFuriganaTextField.text = currentUserG.furigana
        schoolTextField.text = currentUserG.studentParameter!.schoolName
        gradeTextField.text = transformGrade(currentUserG.grade)
        choiceTextField.text = (currentUserG.studentParameter?.choice.first ?? []).first ?? ""
        selectionTextField.text = currentUserG.selection
        parentsEmailTextField.text = currentUserG.studentParameter?.parentEmailAdress
        introductionTextView.text = currentUserG.introduction
        userImageView.image = userImagesCacheG[currentUserG.userId] ?? UIImage(named: "studentNoImage.png")
    }
    
    @IBAction func showMenu(){
        let alertController = UIAlertController(title: "メニュー", message: "メニューを選択して下さい。", preferredStyle: .actionSheet)
        let  signOutAction = UIAlertAction(title: "ログアウト", style: .default) { (action) in
            NCMBUser.logOutInBackground { (error) in
                if error != nil {
                    self.showOkAlert(title: "Error", message: error!.localizedDescription)
                } else {
                    //ログアウト成功
                    let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(identifier: "RootNavigationController")
                    
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                    
                    //ログイン状態の保持
                    let ud = UserDefaults.standard
                    ud.set(false, forKey: "isLogin")
                    ud.synchronize()
                }
            }
        
            }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(signOutAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
  

}
