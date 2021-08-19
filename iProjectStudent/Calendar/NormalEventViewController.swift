//
//  CollageEventViewController.swift
//  iProjectTeacher
//
//  Created by 田中義久 on 2021/06/24.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB
import CalculateCalendarLogic

class NormalEventViewController: UIViewController, UITextFieldDelegate {
    
    var sentDate: Date!
    var eventType: String!
    var schedule: Schedule?
    var bookingList = [BookingData]()
    
    var didSelectBookingSchedule = false
    private var size: Size!
    private var toolBar:UIToolbar!
    private var tagNum: Int8!
    private var firstDate: Date!
    private var firstTime: Date!
    private var endDate: Date!
    private var endTime: Date!
    private var limitDate: Date!
    private var selectedDate: Date!
    private var isShownTableView = true
    private var dateView = UIView()
    private var dateTableView = UITableView()
    private var savedDate: [[Date]] = []
    private var alert: UIAlertController?
    
    @IBOutlet private var titleTextField: UITextField!
    @IBOutlet private var textTextView: UITextView!
    @IBOutlet private var firstDateTextField: UITextField!
    @IBOutlet private var firstTimeTextField: UITextField!
    @IBOutlet private var endDateTextField: UITextField!
    @IBOutlet private var endTimeTextField: UITextField!
    @IBOutlet private var changeInputFormButton: UIButton!
    @IBOutlet private var showSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        size = getScreenSize(isExsistsNavigationBar: true, isExsistsTabBar: true)
        let tmp = Calendar(identifier: .gregorian)
        
        if schedule == nil{
            let d = Date()
            let start = tmp.date(from: DateComponents(hour: d.h, minute: d.min))!
            let end = tmp.date(byAdding: .hour, value: 1, to: start)!
            let now = Date()
            limitDate = tmp.date(from: DateComponents(year: now.y, month: now.m, day: now.d))!
            if sentDate < limitDate {
                sentDate = limitDate
                showOkAlert(title: "注意", message: limitDate.ymdJp + "以降の予定しか追加できません。")
            }
            savedDate.append([sentDate, start, end])
            
            sentDate = tmp.date(from: DateComponents(year: sentDate.y, month: sentDate.m, day: sentDate.d))!
            firstDate = sentDate
            endDate = sentDate
            firstTime = start
            endTime = end
            
            dateView.frame = CGRect(x: 0.f, y: 0.f, width: 242.f, height: 242.f)
            dateView.center = CGPoint(x: size.width / 2.f, y: 293.f)
            dateView.backgroundColor = dColor.base
            dateTableView.frame = CGRect(x: 0.f, y: 0.f, width: 242.f, height: 242.f)
            dateTableView.backgroundColor = dColor.base
            setTableView()
            dateView.addSubview(dateTableView)
            self.view.addSubview(dateView)
            
            switch eventType {
            case "school":
                self.navigationItem.title = "学校の予定を追加"
                showSwitch.isOn = true
            case "private":
                self.navigationItem.title = "個人的な予定を追加"
                showSwitch.isOn = false
            default:
                break
            }
            
        } else {
            titleTextField.text = schedule!.title
            textTextView.text = schedule!.detail
            eventType = schedule!.eventType
            var d = schedule!.detailTimeList.first!.first!
            sentDate = tmp.date(from: DateComponents(year: d.y, month: d.m, day: d.d))!
            firstDate = sentDate
            firstTime = tmp.date(from: DateComponents(hour: d.h, minute: d.min))!
            d = schedule!.detailTimeList.last!.last!
            endDate = tmp.date(from: DateComponents(year: d.y, month: d.m, day: d.d))!
            endTime = tmp.date(from: DateComponents(hour: d.h, minute: d.min))!
            d = Date()
            limitDate = tmp.date(from: DateComponents(year: d.y, month: d.m, day: d.d))!
            for dList in schedule!.detailTimeList{
                if(tmp.date(from: DateComponents(year: dList[0].y, month: dList[0].m, day: dList[0].d))! == tmp.date(from: DateComponents(year: dList[1].y, month: dList[1].m, day: dList[1].d))!){
                    let sd = tmp.date(from: DateComponents(year: dList[0].y, month: dList[0].m, day: dList[0].d))!
                    let st = tmp.date(from: DateComponents(hour: dList[0].h, minute: dList[0].min))!
                    let et = tmp.date(from: DateComponents(hour: dList[1].h, minute: dList[1].min))!
                    savedDate.append([sd,st,et])
                } else {
                    isShownTableView = false
                    changeInputFormButton.isEnabled = false
                    changeInputFormButton.alpha = 0.f
                    break
                }
            }
            
            showSwitch.isOn = schedule!.isAbleToShow
            
            if isShownTableView{
                dateView.frame = CGRect(x: 0.f, y: 0.f, width: 242.f, height: 242.f)
                dateView.center = CGPoint(x: size.width / 2.f, y: 293.f)
                dateView.backgroundColor = dColor.base
                dateTableView.frame = CGRect(x: 0.f, y: 0.f, width: 242.f, height: 242.f)
                dateTableView.backgroundColor = dColor.base
                setTableView()
                dateView.addSubview(dateTableView)
                self.view.addSubview(dateView)
            }
            
            switch eventType {
            case "school":
                self.navigationItem.title = "学校の予定を編集"
            case "private":
                self.navigationItem.title = "個人的な予定を編集"
            default:
                break
            }
        }
        
        setupToolbar()
        
        firstDateTextField.delegate = self
        firstDateTextField.tag = 1
        firstTimeTextField.delegate = self
        firstTimeTextField.tag = 2
        endDateTextField.delegate = self
        endDateTextField.tag = 3
        endTimeTextField.delegate = self
        endTimeTextField.tag = 4
        
        firstDateTextField.text = sentDate.ymdJp
        firstTimeTextField.text = firstTime.hmJp
        endDateTextField.text = sentDate.ymdJp
        endTimeTextField.text = endTime.hmJp

        setBackGround(true, true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        saveBookingSchedule()
    }
}

//NCMBへの保存部分
extension NormalEventViewController: ScheduleClassDelegate{
    
    func savedSchedule() {
        alert?.dismiss(animated: true, completion: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    private func saveBookingSchedule(){
        if didSelectBookingSchedule{
            let c = Calendar(identifier: .gregorian)
            var detailTimeList = [[Date]]()
            var savedIndexList = [Int]()
            for b in bookingList{
                if b.isSelectFirst{
//                    元々あるスケジュールが優先された時は新しいスケジュールの時間を分割する。
                    for i in b.index{
                        let d1 = Date().mixDateAndTime(date: savedDate[i][0], time: savedDate[i][1])
                        let d2 = Date().mixDateAndTime(date: savedDate[i][0], time: savedDate[i][2])
                        let detailTimes = [d1,d2]
                        if savedIndexList.contains(i){
                            
                        } else{
                            savedIndexList.append(i)
                            detailTimeList.append(detailTimes)
                        }
                    }
                } else{
//                    元々あるスケジュールより新しいスケジュールが優先されたとき、古いスケジュールのデータを削除して追加する。
                    if b.isFirstSchedule{
                        for i in b.index{
                            let d1 = Date().mixDateAndTime(date: savedDate[i][0], time: savedDate[i][1])
                            let d2 = Date().mixDateAndTime(date: savedDate[i][0], time: savedDate[i][2])
                            let detailTimes = [d1,d2]
                            let schedule = cachedScheduleG[b.id]!
                            var scheduleDetailTimeList = [[Date]]()
                            for dTimes in schedule.detailTimeList{
                                if (detailTimes[1] < dTimes[0] || dTimes[1] < detailTimes[0] ){
                                    scheduleDetailTimeList.append(dTimes)
                                }
                            }
                            if scheduleDetailTimeList.count == 0{
                                let id = schedule.ncmb.objectId ?? ""
                                let object = NCMBObject(className: "Schedule", objectId: id)
                                object?.deleteInBackground({ error in
                                    if error == nil{
                                        cachedScheduleG[id] = nil
                                    } else {
                                        print("Deleting schedule data error!", error!.localizedDescription)
                                    }
                                })
                            } else{
                                schedule.detailTimeList = scheduleDetailTimeList
                                schedule.save(self)
                            }
                            if !savedIndexList.contains(i){
                                savedIndexList.append(i)
                                detailTimeList.append(detailTimes)
                            }
                        }
                    } else {
                        for i in b.index{
                            let d1 = Date().mixDateAndTime(date: savedDate[i][0], time: savedDate[i][1])
                            let d2 = Date().mixDateAndTime(date: savedDate[i][0], time: savedDate[i][2])
                            let detailTimes = [d1,d2]
                            let lecture = cachedLectureG[b.id]!
                            var lectureDetailTimeList = [Date]()
                            for dTime in lecture.timeList{
                                let start = dTime
                                let end = c.date(byAdding: .hour, value: 1, to: start)!
                                if (detailTimes[1] < start || end < detailTimes[0] ){
                                    lectureDetailTimeList.append(dTime)
                                }
                            }
                            if lectureDetailTimeList.count == 0{
                                let id = lecture.ncmb.objectId ?? ""
                                let object = NCMBObject(className: "Lecture", objectId: id)
                                object?.deleteInBackground({ error in
                                    if error == nil{
                                        cachedLectureG[id] = nil
                                    } else {
                                        print("Deleting lecture data error!", error!.localizedDescription)
                                    }
                                })
                            } else{
                                lecture.timeList = lectureDetailTimeList
                                lecture.save(self)
                            }
                            if !savedIndexList.contains(i){
                                savedIndexList.append(i)
                                detailTimeList.append(detailTimes)
                            }
                        }
                    }
                }
            }
            if detailTimeList.count == 0{
                self.navigationController?.popViewController(animated: true)
            } else{
                if isShownTableView{
                    savedDate = []
                    for dTimes in detailTimeList{
                        let d = c.date(from: DateComponents(year: dTimes[0].y, month: dTimes[0].m, day: dTimes[0].d))!
                        let s = c.date(from: DateComponents(hour: dTimes[0].h, minute: dTimes[0].min))!
                        let e = c.date(from: DateComponents(hour: dTimes[1].h, minute: dTimes[1].min))!
                        savedDate.append([d,s,e])
                    }
                }
                save()
            }
        }
    }
    
    @IBAction private func save(){
        if titleTextField.text!.count == 0{
            showOkAlert(title: "注意", message: "予定のタイトルを入力してください。")
        } else{
            if isShownTableView{
                var detailTimeList = [[Date]]()
                for dlist in savedDate{
                    let d1 = Date().mixDateAndTime(date: dlist[0], time: dlist[1])
                    let d2 = Date().mixDateAndTime(date: dlist[0], time: dlist[2])
                    detailTimeList.append([d1,d2])
                }
                bookingList = searchBookingList(dateList: detailTimeList)
                if bookingList.count == 0 || didSelectBookingSchedule {
//                    予定がブッキングしていない時
                    showWaitingAlert()
                    if schedule == nil{
                        let s = Schedule(title: titleTextField.text!, detail: textTextView.text!, eventType: eventType, detailTimeList: detailTimeList, isAbleToShow: showSwitch.isOn, self)
                        s.delegate = self
                    } else{
                        schedule!.title = titleTextField.text!
                        schedule!.detail = textTextView.text!
                        schedule!.detailTimeList = detailTimeList
                        schedule!.isAbleToShow = showSwitch.isOn
                        schedule!.delegate = self
                        schedule!.save(self)
                    }
                } else{
//                    予定がブッキングしている時
                    showOkAlert(title: "注意", message: "予定が重複しています。\n重複している予定を削除してから\n保存し直してください。") {
                        self.navigationController?.popViewController(animated: true)
                    }
//                    self.performSegue(withIdentifier: "Select", sender: nil)
                }
            } else{
                let first = firstDate.mixDateAndTime(date: firstDate, time: firstTime)
                let end = endDate.mixDateAndTime(date: endDate, time: endTime)
                let detailTimeList = [[first,end]]
                bookingList = searchBookingList(dateList: detailTimeList)
                if bookingList.count == 0{
//                    予定がブッキングしていない時
                    showWaitingAlert()
                    if schedule == nil{
                        let s = Schedule(title: titleTextField.text!, detail: textTextView.text!, eventType: eventType, detailTimeList: detailTimeList, isAbleToShow: showSwitch.isOn, self)
                        s.delegate = self
                    } else{
                        schedule!.title = titleTextField.text!
                        schedule!.detail = textTextView.text!
                        schedule!.detailTimeList = detailTimeList
                        schedule!.isAbleToShow = showSwitch.isOn
                        schedule!.delegate = self
                        schedule!.save(self)
                    }
                } else{
//                    予定がブッキングしている時は強制終了
                    showOkAlert(title: "注意", message: "予定が重複しています。\n重複している予定を削除してから\n保存し直してください。") {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    private func searchBookingList(dateList: [[Date]]) -> [BookingData] {
        let c = Calendar(identifier: .gregorian)
        var ret: [BookingData] = []
        for dateListIndex in 0..<dateList.count{
            let dList = dateList[dateListIndex]
            var dStart = dList[0]
            var dEnd = c.date(from: DateComponents(year: dStart.y, month: dStart.m, day: dStart.d + 1))!
            if dEnd > dList[1]{
                dEnd = dList[1]
            }
            while(dStart < dList[1]){
                for s in cachedScheduleG.values {
                    if s.userId == currentUserG.userId{
                        if s.eventType == "hope" {
                            s.ncmb.deleteInBackground { error in
                                if error != nil{
                                    self.showOkAlert(title: "Deleting hope data error", message: error!.localizedDescription)
                                }
                            }
                        } else{
                            for times in s.detailTimeList{
                                let start = times[0]
                                let end = times[1]
                                if (start < dEnd && dStart < end && ( (schedule == nil) || (schedule != nil && s.ncmb.objectId != schedule!.ncmb.objectId) )){
                                    var k = 0
                                    while k < ret.count{
                                        if s.ncmb.objectId == ret[k].id && ret[k].isFirstSchedule{
                                            break
                                        }
                                        k += 1
                                    }
                                    if k == ret.count{
                                        ret.append(BookingData())
                                        ret[k].date = c.date(from: DateComponents(year: dStart.y, month: dStart.m, day: dStart.d))!
                                        ret[k].id = s.ncmb.objectId
                                        ret[k].isFirstSchedule = true
                                        ret[k].title1 = s.title
                                        ret[k].title2 = titleTextField.text!
                                    }
                                    ret[k].index.append(dateListIndex)
                                    ret[k].timeList.append([[start.h*100+start.min, end.h*100+end.min], [dList[0].h*100+dList[0].min, dList[1].h*100+dList[1].min]])
                                }
                            }
                        }
                    }
                }
                for l in cachedLectureG.values {
                    if l.student.userId == currentUserG.userId{
                        for start in l.timeList{
                            let end = c.date(from: DateComponents(year: start.y, month: start.m, day: start.d, hour: start.h + 1))!
                            if (start < dEnd && dStart < end){
                                var k = 0
                                while k < ret.count{
                                    if l.ncmb.objectId == ret[k].id && !ret[k].isFirstSchedule{
                                        break
                                    }
                                    k += 1
                                }
                                if k == ret.count{
                                    ret.append(BookingData())
                                    ret[k].date = c.date(from: DateComponents(year: dStart.y, month: dStart.m, day: dStart.d))!
                                    ret[k].id = l.ncmb.objectId
                                    ret[k].title1 = l.subjectName + "(" + l.teacher.userName + "先生)"
                                    ret[k].title2 = titleTextField.text!
                                }
                                ret[k].index.append(dateListIndex)
                                ret[k].timeList.append([[start.h*100+start.min, end.h*100+end.min], [dList[0].h*100+dList[0].min, dList[1].h*100+dList[1].min]])
                            }
                        }
                    }
                }
                dStart = c.date(from: DateComponents(year: dStart.y, month: dStart.m, day: dStart.d + 1))!
                dEnd = c.date(from: DateComponents(year: dStart.y, month: dStart.m, day: dStart.d + 1))!
                if dEnd > dList[1]{
                    dEnd = dList[1]
                }
            }
        }
        return ret
    }
    
    private func showWaitingAlert(){
        alert = UIAlertController(title: "保存中", message: "データを保存しています。", preferredStyle: .alert)
        self.present(alert!, animated: true, completion: nil)
    }
}

//画面の日付けの切り替え部分
extension NormalEventViewController{
    @IBAction private func changeInputDateFormat(){
        if isShownTableView {
            dateView.removeFromSuperview()
        } else{
            self.view.addSubview(dateView)
            dateTableView.reloadData()
        }
        isShownTableView = !isShownTableView
    }
}

//テーブルビューの設定
extension NormalEventViewController: UITableViewDataSource, UITableViewDelegate, DateTableViewCellDelegate {
    private func setTableView(){
        dateTableView.dataSource = self
        dateTableView.delegate = self
        dateTableView.tableFooterView = UIView()
        let nib1 = UINib(nibName: "PlusTableViewCell", bundle: Bundle.main)
        let nib2 = UINib(nibName: "DateTableViewCell", bundle: Bundle.main)
        dateTableView.register(nib1, forCellReuseIdentifier: "Plus")
        dateTableView.register(nib2, forCellReuseIdentifier: "Date")
    }
    
//    セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == savedDate.count){
            return 44.f
        }
        else{
            return 203.f
        }
    }
    
//    セルの個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedDate.count + 1
    }
    
//    セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == savedDate.count{
            return tableView.dequeueReusableCell(withIdentifier: "Plus") as! PlusTableViewCell
        } else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Date") as! DateTableViewCell
            cell.limitDate = self.limitDate
            let ir = indexPath.row
            cell.tag = ir
            cell.dateLabel.text = (ir+1).jp + "日目"
            cell.setDate(dates: savedDate[ir])
            cell.delegate = self
            
            cell.setFontColor()
            
            return cell
        }
    }
    
//    セルがタップされた時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == savedDate.count{
            let count = savedDate.count - 1
            var dates = [Date]()
            let tmp = Calendar(identifier: .gregorian)
            let nextDate = tmp.date(byAdding: .day, value: 1, to: savedDate[count][0])!
            dates.append(nextDate)
            dates.append(savedDate[count][1])
            dates.append(savedDate[count][2])
            savedDate.append(dates)
        }
        tableView.reloadData()
    }

//    スワイプしてテーブルビューセルを削除するコード
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return (indexPath.row != savedDate.count) && savedDate.count > 1
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            savedDate.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
        }
    }

//    セル内のテキストフィールドが上書きされた時の処理
    func didSelected(cellId: Int, tag: Int, selectedDate: Date) {
        if tag == 1 && selectedDate < limitDate {
            self.showOkAlert(title: "注意", message: limitDate.ymdJp + "以降の予定しか追加できません。")
            dateTableView.reloadData()
        } else {
            savedDate[cellId][tag-1] = selectedDate
            if tag == 1 && savedDate.count > 1{
                var showIndexPath = IndexPath(row: cellId, section: 0)
//                データの入れ換えを1行で済ませるための関数
                func shuffle(i: Int, j: Int){
                    let dates = savedDate[i]
                    savedDate[i] = savedDate[j]
                    savedDate[j] = dates
                }
//                データの和集合を求めて更新するのを1行で済ませるための関数
                func mix(i: Int){
                    var sTime = savedDate[i][1]
                    var eTime = savedDate[i][2]
                    savedDate.remove(at: i)
                    sTime = min(sTime, savedDate[i][1])
                    eTime = max(eTime, savedDate[i][2])
                    savedDate[i][1] = sTime
                    savedDate[i][2] = eTime
                }
//                日付が変更されたらデータを並び替える必要があるかも。
                var isNeedToBack = true
                if cellId != 0 {
//                    必要なら変更されたデータを前方に移動させる。
                    var i = cellId
                    while i>0 {
                        if(savedDate[i][0] < savedDate[i-1][0] || ( savedDate[i][0] == savedDate[i-1][0] && savedDate[i-1][1] > savedDate[i][2] ) ){
                            isNeedToBack = false
                            shuffle(i: i, j: i-1)
                            showIndexPath.row = i-1
                        }else if(savedDate[i][0] == savedDate[i-1][0] && savedDate[i][1] < savedDate[i-1][2] && savedDate[i][2] < savedDate[i-1][1] ){
                            mix(i: i-1)
                            showIndexPath.row = i-1
                            break
                        }else {
                            break
                        }
                        i -= 1
                    }
                }
                if cellId != savedDate.count - 1 && isNeedToBack {
//                    必要なら変更されたデータを後方に移動させる
                    var i = cellId
                    while i<savedDate.count - 1 {
                        if(savedDate[i][0] > savedDate[i+1][0] || ( savedDate[i][0] == savedDate[i-1][0] && savedDate[i+1][2] > savedDate[i][1] )){
                            shuffle(i: i, j: i+1)
                            showIndexPath.row = i+1
                        }else if(savedDate[i][0] == savedDate[i+1][0] && savedDate[i][1] < savedDate[i+1][2] && savedDate[i][2] < savedDate[i+1][1] ){
                            mix(i: i)
                            showIndexPath.row = i
                            break
                        }else {
                            break
                        }
                        i += 1
                    }
                }
                dateTableView.reloadData()
                DispatchQueue.main.async {
                    self.dateTableView.scrollToRow(at: showIndexPath, at: UITableView.ScrollPosition.top, animated: true)
                }
            }
        }
    }
}

//日付の選択部分
extension NormalEventViewController{
    private func setupToolbar() {
        //datepicker上のtoolbarのdoneボタン
        toolBar = UIToolbar()
        toolBar.sizeToFit()
        let toolBarBtn = UIBarButtonItem(title: "決定", style: .plain, target: self, action: #selector(doneBtn))
        toolBar.items = [toolBarBtn]
        firstDateTextField.inputAccessoryView = toolBar
        firstTimeTextField.inputAccessoryView = toolBar
        endDateTextField.inputAccessoryView = toolBar
        endTimeTextField.inputAccessoryView = toolBar
    }
//    決定ボタンを押したときの処理
    @objc func doneBtn(){
        switch tagNum {
        case Int8(1):
            if selectedDate < limitDate && schedule == nil {
                selectedDate = limitDate
                showOkAlert(title: "注意", message: limitDate.ymdJp + "以降の予定しか追加できません。")
            }
            firstDate = selectedDate
            firstDateTextField.text = firstDate.ymdJp
            if endDate < firstDate{
                endDate = selectedDate
                endDateTextField.text = endDate.ymdJp
            }
            firstDateTextField.resignFirstResponder()
        case Int8(2):
            firstTime = selectedDate
            firstTimeTextField.text = selectedDate.hmJp
            if endDate == firstDate && endTime < firstTime{
                endTime = selectedDate
                endTimeTextField.text = selectedDate.hmJp
            }
            firstTimeTextField.resignFirstResponder()
        case Int8(3):
            if selectedDate < limitDate && schedule == nil  {
                selectedDate = limitDate
                showOkAlert(title: "注意", message: limitDate.ymdJp + "以降の予定しか追加できません。")
            }
            endDate = selectedDate
            endDateTextField.text = endDate.ymdJp
            if endDate < firstDate{
                firstDate = selectedDate
                firstDateTextField.text = firstDate.ymdJp
            }
            endDateTextField.resignFirstResponder()
        case Int8(4):
            endTime = selectedDate
            endTimeTextField.text = selectedDate.hmJp
            if endDate == firstDate && endTime < firstTime{
                firstTime = selectedDate
                firstTimeTextField.text = selectedDate.hmJp
            }
            endTimeTextField.resignFirstResponder()
        default:
            break
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tagNum = Int8(textField.tag)
        let datePickerView:UIDatePicker = UIDatePicker()
//        スイッチ文にしてselectedDateの初期値を指定する。
        switch textField.tag {
        case 1:
            datePickerView.datePickerMode = UIDatePicker.Mode.date
            datePickerView.setDate(self.firstDate, animated: false)
            selectedDate = self.firstDate
        case 2:
            datePickerView.datePickerMode = UIDatePicker.Mode.time
            datePickerView.setDate(self.firstTime, animated: false)
            selectedDate = self.firstTime
        case 3:
            datePickerView.datePickerMode = UIDatePicker.Mode.date
            datePickerView.setDate(self.endDate, animated: false)
            selectedDate = self.endDate
        case 4:
            datePickerView.datePickerMode = UIDatePicker.Mode.time
            datePickerView.setDate(self.endTime, animated: false)
            selectedDate = self.endTime
        default:
            return
        }
        datePickerView.preferredDatePickerStyle = .wheels
        textField.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // キーボード入力や、カット/ペースによる変更を防ぐ
        return textField.tag == 0
    }
    //datepickerが選択されたらselectedDateを更新
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        selectedDate = sender.date
    }
    
}

//値渡し用
extension NormalEventViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! SelectBookingEventViewController
        nextVC.beforeVC = self
        didSelectBookingSchedule = true
    }
}