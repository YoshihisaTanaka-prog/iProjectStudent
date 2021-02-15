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
    @IBOutlet var pickerView1: UIPickerView!
    @IBOutlet var introductionTextView: UITextView!

    var selected: String?
    let bunri = ["文理選択","文系","理系","その他"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2.0
        userImageView.layer.masksToBounds = true
        
        userIdTextField.delegate = self
        userIdFuriganaTextField.delegate = self
        schoolTextField.delegate = self
        gradeTextField.delegate = self
        emailTextField.delegate = self
        parentsEmailTextField.delegate = self
        pickerView1.delegate = self
        pickerView1.dataSource = self
        introductionTextView.delegate = self
        
        let userId = NCMBUser.current()?.userName
        let user = NCMBUser.current()
        userIdTextField.text = userId
        userIdFuriganaTextField.text = user!.object(forKey: "furigana") as? String
//      emailTextField.text = email
        
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
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveUserInfo(){
        let user = NCMBUser.current()
//        user?.setObject(userIdTextField, forKey: "userName")
        user?.setObject(userIdFuriganaTextField, forKey: "furigana")
//        user?.setObject(schoolTextField, forKey: "SchoolName")
 //       user?.setObject(gradeTextField, forKey: "grade")
//        user?.setObject(emailTextField, forKey: "mailAddress")
//        user?.setObject(parentsEmailTextField, forKey: "parentEmailAdress")
//        user?.setObject(selected!, forKey: "selection")
 //       user?.setObject(introductionTextView, forKey: "userName")
        user?.saveInBackground({ (error) in
            if error != nil {
                print(error)
            } else {
                self.dismiss(animated: true, completion: nil)
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
}
