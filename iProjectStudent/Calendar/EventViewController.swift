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
    @IBOutlet private var eventText: UITextView!
    //日付フォーム(UIDatePickerを使用)
    @IBOutlet private var y: UIDatePicker!
    //日付表示
    @IBOutlet private var y_text: UILabel!
    @IBOutlet private var pickerView: UIPickerView!
    @IBOutlet private var subjectPickerView: UIPickerView!
    @IBOutlet private var datePickerView: UIPickerView!
    @IBOutlet private var studentLabel: UILabel!
    
    var teacher: User?
    private let formatter = DateFormatter()
    private var subjectName = "教科を選択"
    private var subjectNameList = ["教科を選択","国語","数学","理科","社会","英語"]
    private var dateList = [[],[],["月","火","水","木","金","土","日"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackGround(true, true)
        
        eventText.text = ""
        eventText.layer.borderWidth = 1.f
        eventText.layer.borderColor = UIColor.black.cgColor
        eventText.layer.cornerRadius = 10.f
        
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.tag = 1
        subjectPickerView.dataSource = self
        subjectPickerView.delegate = self
        subjectPickerView.tag = 2
        datePickerView.dataSource = self
        datePickerView.delegate = self
        datePickerView.tag = 3
        
        formatter.dateFormat = "yyyy/MM/dd"
        y_text.text = formatter.string(from: y.date)
        
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        //日付の選択
        for y in year-1..<year+3 {
            dateList[0].append(y.s+"年")
        }
        for i in 1...12 {
            dateList[1].append(i.s + "月")
        }
        for i in 0..<dateList[2].count {
            dateList[2][i] = dateList[2][i] + "曜日"
        }
        
    }

    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerView.tag
    }
    
    //要修正
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return 0;
        case 2:
            return 0;
        default:
            return dateList[component].count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return 0.s;
        case 2:
            return 0.s;
        default:
            return dateList[component][row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            break
        case 2:
            break
        case 3:
            break
        default:
            break
        }
        subjectName = subjectNameList[row]
    }
    
    
    //画面遷移(カレンダーページ)
    @IBAction func onbackClick(_: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    //日付フォーム
//    @IBAction func picker(){
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy/MM/dd"
//        y_text.text = formatter.string(from: y.date)
//    }

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
