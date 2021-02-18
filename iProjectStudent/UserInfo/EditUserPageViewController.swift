//
//  EditUserPageViewController.swift
//  iProjectStudent
//
//  Created by Kaori Nakamura on 2/13/21.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB
import NYXImagesKit

class EditUserPageViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userIdTextField: UITextField!
    @IBOutlet var userIdFuriganaTextField: UITextField!
    @IBOutlet var schoolTextField: UITextField!
    @IBOutlet var gradeTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var parentsEmailTextField: UITextField!
    @IBOutlet var selectionTextField: UITextField!
    @IBOutlet var choiceTextField: UITextField!
    @IBOutlet var pickerView1: UIPickerView!
    @IBOutlet var introductionTextView: UITextView!

    var selected: String?
    let bunri = ["文理選択","文系","理系","その他"]
    var youbiCheckBox: CheckBox!
    let youbiList: [CheckBoxInput] = [
        CheckBoxInput("月曜日"),
        CheckBoxInput("火曜日"),
        CheckBoxInput("水曜日"),
        CheckBoxInput("木曜日"),
        CheckBoxInput("金曜日"),
        CheckBoxInput("土曜日", color: .blue),
        CheckBoxInput("日曜日", color: .red)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        youbiCheckBox = CheckBox(youbiList,size: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2.0
        userImageView.layer.masksToBounds = true
        
        userIdTextField.delegate = self
        userIdFuriganaTextField.delegate = self
        schoolTextField.delegate = self
        gradeTextField.delegate = self
        emailTextField.delegate = self
        parentsEmailTextField.delegate = self
//        pickerView1.delegate = self
//        pickerView1.dataSource = self
        choiceTextField.delegate = self
        introductionTextView.delegate = self
        

        
        let userId_ = NCMBUser.current()?.userName
        let mailAddress_ = NCMBUser.current()?.mailAddress
        let userIdFurigana = NCMBUser.current()?.setObject(userIdFuriganaTextField.text, forKey: "furigana")
        let user_ = User(NCMBUser.current())
        userIdTextField.text = userId_
        emailTextField.text = mailAddress_
        //userIdFuriganaTextField.text = userIdFurigana!
        schoolTextField.text = user_.studentParameter?.SchoolName
        gradeTextField.text = user_.studentParameter?.grade
        selectionTextField.text = user_.studentParameter?.selection
        parentsEmailTextField.text = user_.studentParameter?.parentEmailAdress
        
        
        let file = NCMBFile.file(withName: (NCMBUser.current()?.objectId)! + ".png", data: nil) as! NCMBFile
        file.getDataInBackground { (data, error) in
            if error != nil {
            print(error)
        } else {
            if error != nil{
                let image = UIImage(data: data!)
                self.userImageView.image = image
            }
        }
    }

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        let resizedImage = selectedImage.scale(byFactor: 0.4)
        
        picker.dismiss(animated: true, completion: nil)
        
        let data = UIImage.pngData(resizedImage!)
        let file = NCMBFile.file(withName: NCMBUser.current()?.objectId, data: data()) as! NCMBFile
        file.saveInBackground { (error) in
            if error != nil{
                print(error)
            } else {
                self.userImageView.image = selectedImage
            }
        } progressBlock: { (progress) in
            print(progress)
        }
        
    }
  

    // UIPickerViewの列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // UIPickerViewの行数、リストの数
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return bunri.count
        
    }
    
    // UIPickerViewの最初の表示
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return bunri[row]
        
    }
    
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        if row != 0 {
            selected = bunri[row]
        } else {
            selected = nil
        }
    }

    
    @IBAction func closeEditViewController(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveUserInfo(){
        let user = NCMBUser.current()
        user?.setObject(userIdTextField.text, forKey: "userName")
        user?.setObject(userIdFuriganaTextField.text, forKey: "furigana")
        user?.setObject(schoolTextField.text, forKey: "SchoolName")
        user?.setObject(gradeTextField.text, forKey: "grade")
        user?.setObject(choiceTextField.text, forKey: "choice")
        user?.setObject(parentsEmailTextField.text, forKey: "parentEmailAdress")
        //user?.setObject(selected!, forKey: "selection")
        user?.setObject(emailTextField.text, forKey: "mailAddress")
        user?.setObject(introductionTextView.text, forKey: "introduction")
        user?.saveInBackground({ (error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
            })

        }
    
    @IBAction func selectImage() {
        let actionController = UIAlertController(title: "画像の選択", message: "選択して下さい", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "カメラ", style: .default) { (action) in
            //カメラ起動
            if UIImagePickerController.isSourceTypeAvailable(.camera) == true {
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            } else {
                self.showOkAlert(title: "エラー", message: "この機種ではカメラが使用出来ません。")
            }
        }
        let albumAction = UIAlertAction(title: "フォトライブラリ", style: .default) { (action) in
            //アルバム起動
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == true {
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            } else {
                self.showOkAlert(title: "エラー", message: "この機種ではフォトライブラリが使用出来ません。")
            }
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            actionController.dismiss(animated: true, completion: nil)
        }
        actionController.addAction(cameraAction)
        actionController.addAction(albumAction)
        actionController.addAction(cancelAction)
        self.present(actionController, animated: true, completion: nil)
    }
    
    @IBAction func selectWeek(){
        let alertController = UIAlertController(title: "", message: "曜日を選んでください。", preferredStyle: .alert)
        let alertOkAction = UIAlertAction(title: "選択完了", style: .default) { (action) in
            self.youbiCheckBox.mainView.removeFromSuperview()
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(alertOkAction)
        let width = alertController.view.frame.width
        let height = alertController.view.frame.height + youbiCheckBox.height
        youbiCheckBox.mainView.frame = CGRect(x: width / 10.f, y: 50, width: width * 0.8, height: youbiCheckBox.height)
        alertController.view.addSubview(youbiCheckBox.mainView)
        self.present(alertController, animated: true, completion: nil)
//        alertController.view.
    }
}
