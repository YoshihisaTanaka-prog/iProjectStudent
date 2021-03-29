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
//    予定の種類
    private var numOfSelectedPurpose = 0
    private let purposeList = ["-----","TeLecture授業の予約","学校行事","自習・その他の塾","私用"]
//    強化選択
    private var selectedSubject = ""
    private let mainSubjectList = [["教科を選択",""],["国語",""],["数学",""],["理科",""],["社会",""],["英語","English"]]
    private let subSubjectList = [
        [["------",""]],
        [["詳細を選択",""],["現代文","modernWriting"],["古文","ancientWiting"],["漢文","chineseWriting"]],
        [["詳細を選択",""],["数学Ⅰ・A","math1a"],["数学Ⅱ・B","math2b"],["数学Ⅲ・C","math3c"]],
        [["詳細を選択",""],["物理","physics"],["化学","chemistry"],["生物","biology"],["地学","earthScience"]],
        [["詳細を選択",""],["地理","geography"],["日本史","japaneseHistory"],["世界史","worldHistory"],
         ["現代社会","modernSociety"],["倫理","ethics"],["政治・経済","politicalScienceAndEconomics"]],
        [["-----","English"]]
    ]
    private var selectedSubjectList: [[String]] = [["------",""]]
//    日時指定
    private var dateList: [[String]] = [["-----"],["---"],["--"],["--"],["-----","16時-","17時-","18時-","19時-","20時-","21時-","22時-"]]
    private var selectedTimeList: [Int] = [-1,-1,-1,-1,-1]
    private var maxDateList = [31,28,31,30,31,30,31,31,30,31,30,31]
    private var maxDate = 0
    
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
        datePickerView.tag = 5
        formatter.dateFormat = "yyyy/MM/dd"
//        y_text.text = formatter.string(from: y.date)
        
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        //日付の選択
        for y in year...year+3 {
            dateList[0].append(y.s+"年")
        }
    }

    
//    ピッカービューの横の個数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == 2 && [0,2,4].contains(numOfSelectedPurpose){
            return 1
        }
        return pickerView.tag
    }
//    各ピッカービューの各縦部分の個数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return purposeList.count;
        case 2:
            if [1,3].contains(numOfSelectedPurpose){
            switch component {
                case 0:
                    return mainSubjectList.count
                case 1:
                    return selectedSubjectList.count
                default:
                    return 0
                }
            } else{
                return 1
            }
        case 5:
            return dateList[component].count
        default:
            return 0
        }
    }
//    ピッカービューの幅の長さを指定
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let width = pickerView.frame.width
        switch pickerView.tag {
        case 1:
            return width
        case 2:
            return width / 2.f
        case 5:
            switch component {
            case 0:
                return width / 3.f
            case 1:
                return width / 6.f
            case 2:
                return width / 16.f
            case 3:
                return width / 7.f
            case 4:
                return width / 4.f
            default:
                return 0
            }
        default:
            return 0.f
        }
    }
//    ピッカービューの選択肢を指定
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return purposeList[row]
        case 2:
            if [1,3].contains(numOfSelectedPurpose){
                switch component {
                case 0:
                    return mainSubjectList[row][0]
                case 1:
                    return selectedSubjectList[row][0]
                default:
                    return ""
                }
            } else{
                return "----------"
            }
        case 5:
            return dateList[component][row]
        default:
            return ""
        }
    }
//    ピッカービューが選ばれた時の処理
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            numOfSelectedPurpose = row
            subjectPickerView.reloadAllComponents()
            subjectPickerView.selectRow(0, inComponent: 0, animated: true)
            if [1,3].contains(numOfSelectedPurpose){
                subjectPickerView.selectRow(0, inComponent: 1, animated: true)
            } else{
                selectedSubject = ""
            }
        case 2:
            if [1,3].contains(numOfSelectedPurpose){
                switch component {
                case 0:
                    selectedSubjectList = subSubjectList[row]
                    pickerView.reloadComponent(1)
                    pickerView.selectRow(0, inComponent: 1, animated: true)
                    selectedSubject = mainSubjectList[row][1]
                    print(selectedSubject)
                case 1:
                    selectedSubject = selectedSubjectList[row][1]
                    print(selectedSubject)
                default:
                    break
                }
            }
        case 5:
            switch component {
            case 0:
                let date = Date()
                let calendar = Calendar.current
                let year = calendar.component(.year, from: date)
                selectedTimeList[0] = year + row - 1
                if(isLeapYear( year + row - 1 )){
                    maxDateList[1] = 29
                } else{
                    maxDateList[1] = 28
                }
                dateList[1] = []
                for i in 1...12 {
                    dateList[1].append(i.s+"月")
                }
                pickerView.reloadComponent(1)
                pickerView.selectRow(0, inComponent: 1, animated: true)
            case 1:
                selectedTimeList[1] = row + 1
                dateList[2] = []
                dateList[3] = ["-日"]
                maxDate = maxDateList[row]
                for i in 0...maxDate/10 {
                    dateList[2].append(i.s)
                }
                pickerView.reloadComponent(2)
                pickerView.selectRow(0, inComponent: 2, animated: true)
            case 2:
                selectedTimeList[2] = row
                dateList[3] = []
                if(maxDate - row*10 < 10){
                    for i in 0...maxDate%10 {
                        dateList[3].append(i.s + "日")
                    }
                } else if(row == 0){
                    for i in 1...9 {
                        dateList[3].append(i.s + "日")
                    }
                } else{
                    for i in 0...9 {
                        dateList[3].append(i.s + "日")
                    }
                }
                pickerView.reloadComponent(3)
                pickerView.selectRow(0, inComponent: 3, animated: true)
            case 3:
                selectedTimeList[3] = row + 10 - dateList[3].count
            case 4:
                if row == 0{
                    selectedTimeList[4] = -1
                } else{
                    selectedTimeList[4] = row + 15
                }
                print(selectedTimeList)
            default:
                break
            }
        default:
            break
        }
    }
    
    private func isLeapYear(_ year : Int) -> Bool{
        if year % 400 == 0{
            return true
        }
        if year % 100 == 0{
            return false
        }
        if year % 4 == 0{
            return true
        }
        return false
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
        if(numOfSelectedPurpose == 0){
            showOkAlert(title: "注意", message: "イベントの種類を選んでください")
        }
        else if(selectedTimeList.contains(-1)){
            showOkAlert(title: "注意", message: "日時を入力してください。")
        }
        else{
            let object = NCMBObject(className:"ScheduleStudent")
            let date = selectedTimeList[0].s + "/" + String(format: "%02d", selectedTimeList[1]) + "/" + selectedTimeList[2].s + selectedTimeList[3].s
            object?.setObject(NCMBUser.current().objectId,forKey:"studentId")
            object?.setObject(teacher?.userId,forKey:"teacherId")
            object?.setObject(selectedSubject, forKey:"subject" )
            object?.setObject(date, forKey: "whenDo")
            object?.setObject(selectedTimeList[4], forKey: "time")
            object?.setObject(eventText.text, forKey: "whatToDo")
            switch numOfSelectedPurpose {
            case 1:
                object?.setObject("telecture",forKey:"eventType")
            case 2:
                object?.setObject("school",forKey:"eventType")
            case 3:
                object?.setObject("otherStudy",forKey:"eventType")
            case 4:
                object?.setObject("private",forKey:"eventType")
            default:
                break
            }
            object?.saveInBackground({ (error) in
                if(error == nil){
                    /*
                    print("データ書き込み開始")
                    let realm = try! Realm()
                    try! realm.write {
                        //日付表示の内容とスケジュール入力の内容が書き込まれる。
                        let Events = [Event(value: ["date": self.y_text.text, "event":self.eventText.text!, "teacherId": self.teacher?.userId, "studentId": NCMBUser.current()!.objectId, "kind": self.selectedSubject, "id": object!.objectId])]
                        realm.add(Events)
                        print("データ書き込み中")
                    }
                    print("データ書き込み完了") */
                    //前のページに戻る
                    self.navigationController?.popViewController(animated: true)
                    
                }else{
                    self.showOkAlert(title: "Error", message: error!.localizedDescription)
                }
            })
            
        }
    }
    
}
