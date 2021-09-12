//
//  Teacher_review_ViewController.swift
//  iProjectStudent
//
//  Created by Kaori Nakamura on 6/9/21.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB
import NYXImagesKit

class Teacher_review_ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate {
    
    @IBOutlet private var tangenTextField: UITextField!
    @IBOutlet private var pickerView1: UIPickerView!
    @IBOutlet private var reviewTextView: UITextView!

    private var selected: String?
    private let hyouka = ["先生の授業態度を選択してください","大変良い","まあまあ良い","普通","やや改善が必要","改善が必要"]
    private var report: Teacher_Review!
    
    private var isTextViewActive = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackGround(true, true)
        
        setUpTextViewCloseButton()
        
//        userImageView.layer.cornerRadius = userImageView.bounds.width / 2.0
//        userImageView.layer.masksToBounds = true
        
        tangenTextField.delegate = self
        pickerView1.delegate = self
        pickerView1.dataSource = self
        reviewTextView.delegate = self

        tangenTextField.text = ""
        reviewTextView.text = ""
        pickerView1.selectRow(0, inComponent: 0, animated: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
 
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }

    // UIPickerViewの列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // UIPickerViewの行数、リストの数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return hyouka.count
        
    }
    
    // UIPickerViewの最初の表示
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return hyouka[row]
        
    }
    
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row != 0 {
            selected = hyouka[row]
        } else {
            selected = nil
        }
    }

    
    @IBAction func closeEditViewController(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveUserInfo(){
        if(selected != nil){
            let object = report.ncmb
            //object.setObject(report.studentId, forKey: "studentId")
            //object.setObject(report.teacherId, forKey: "teacherId")
            //object.setObject(report.subject, forKey: "subject")
            //object.setObject(report.unit, forKey: "unit")
            //object.setObject(report.attitude, forKey: "attitude")
            //object.setObject(report.homework, forKey: "homework")
            //object.setObject(report.nextUnit, forKey: "nextUnit")
            //object.setObject(report.messageToParents, forKey: "messageToParents")
            //object.setObject(report.messageToTeacher, forKey: "messageToTeacher")
            //object.setObject(report.fileNames, forKey: "fileNames")
            object.saveInBackground{ (error) in
                if error != nil {
                    self.showOkAlert(title: "Error", message: error!.localizedDescription)
                } else {
                    //self.sendReportEmailToParent(object.objectId)
                }
            }
        }
    }
}

extension Teacher_review_ViewController: UITextViewDelegate{
    
    private func setUpTextViewCloseButton(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let toolBarBtn = UIBarButtonItem(title: "決定", style: .plain, target: self, action: #selector(closeBtn))
        toolBar.items = [toolBarBtn]
        reviewTextView.inputAccessoryView = toolBar
        reviewTextView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        isTextViewActive = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        isTextViewActive = false
    }
    
    @objc private func closeBtn(){
        reviewTextView.resignFirstResponder()
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.isTextViewActive{
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
        }
    }
    
    @objc private func keyboardWillHide() {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
