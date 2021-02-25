//
//  EventViewController.swift
//  iProjectTeacher
//
//  Created by Ryusei Hiraoka on 2021/02/10.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//
import UIKit
import RealmSwift
import NCMB

class EventViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //スケジュール内容入力テキスト
    @IBOutlet var eventText: UITextView!
    //日付フォーム(UIDatePickerを使用)
    @IBOutlet var y: UIDatePicker!
    //日付表示
    @IBOutlet var y_text: UILabel!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var studentLabel: UILabel!
    
    var teacher: User?
    let formatter = DateFormatter()
    
    var subjectName = "教科を選択"
    var subjectNameList = ["教科を選択","国語","数学","理科","社会","英語"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackGround(true, true)
        
        eventText.text = ""
        eventText.layer.borderWidth = 1.f
        eventText.layer.borderColor = UIColor.black.cgColor
        eventText.layer.cornerRadius = 10.f
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        formatter.dateFormat = "yyyy/MM/dd"
        y_text.text = formatter.string(from: y.date)
        
    }

    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return subjectNameList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return subjectNameList[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        subjectName = subjectNameList[row]
    }
    
    //画面遷移(カレンダーページ)
    @IBAction func onbackClick(_: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    //日付フォーム
    @IBAction func picker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        y_text.text = formatter.string(from: y.date)
    }

    //DB書き込み処理
    @IBAction func saveEvent(_ : UIButton){
        if(subjectName == "教科を選択"){
            showOkAlert(title: "注意", message: "教科を選択してください。")
            pickerView.backgroundColor = .yellow
        }
        else if(eventText.text.count == 0){
            showOkAlert(title: "注意", message: "イベントを入力してください。")
            eventText.backgroundColor = .yellow
        }
        else{
            let object = NCMBObject(className:"ScheduleStudent")
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            let date = formatter.string(from: y.date)
            object?.setObject(NCMBUser.current().objectId,forKey:"studentId")
            object?.setObject(teacher?.userId,forKey:"teacherId")
            object?.setObject(subjectName, forKey:"subject" )
            object?.setObject(date, forKey: "whenDo")
            object?.setObject(eventText.text, forKey: "whatToDo")
            object?.saveInBackground({ (error) in
                if(error == nil){
                    //前のページに戻る
                    print("データ書き込み開始")
                    
                    let realm = try! Realm()
                    
                    try! realm.write {
                        //日付表示の内容とスケジュール入力の内容が書き込まれる。
                        let Events = [Event(value: ["date": self.y_text.text, "event":self.eventText.text!, "teacherId": self.teacher?.userId, "studentId": NCMBUser.current()!.objectId, "kind": self.subjectName, "id": object!.objectId])]
                        realm.add(Events)
                        print("データ書き込み中")
                    }
                    
                    print("データ書き込み完了")
                    self.navigationController?.popViewController(animated: true)
                    
                }else{
                    
                self.showOkAlert(title: "Error", message: error!.localizedDescription)
                }
            })
            
        }
    }
    
}
