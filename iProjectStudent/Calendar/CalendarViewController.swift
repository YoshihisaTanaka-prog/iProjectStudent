//
//  CalendarViewController.swift
//  iProjectTeacher
//
//  Created by Ryusei Hiraoka on 2021/02/10.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic
import RealmSwift
import NCMB

class CalendarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    var teacher: User?
    
    private var eventList: [Event] = []
    private var selectedDate = Date()
    private var currentMonth: Int!
    
    @IBOutlet private var tableView: UITableView!  //スケジュール内容
    @IBOutlet private var labelTitle: UILabel!  //「主なスケジュール」の表示
    //カレンダー部分
    @IBOutlet private var datelabel: UILabel!  //日付の表示
    @IBOutlet private var calenderView: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.layer.borderWidth = 1.f
        tableView.layer.borderColor = dColor.concept.cgColor
        setBackGround(true, true)
        if teacher != nil {
            self.navigationItem.title = teacher!.userName + "先生のスケジュール"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        calenderView.appearance.headerDateFormat = "YYYY年M月"
        calenderView.appearance.headerTitleColor = dColor.font
        calenderView.calendarWeekdayView.weekdayLabels[0].text = "日"
        calenderView.calendarWeekdayView.weekdayLabels[0].textColor = .red
        calenderView.calendarWeekdayView.weekdayLabels[1].text = "月"
        calenderView.calendarWeekdayView.weekdayLabels[1].textColor = dColor.font
        calenderView.calendarWeekdayView.weekdayLabels[2].text = "火"
        calenderView.calendarWeekdayView.weekdayLabels[2].textColor = dColor.font
        calenderView.calendarWeekdayView.weekdayLabels[3].text = "水"
        calenderView.calendarWeekdayView.weekdayLabels[3].textColor = dColor.font
        calenderView.calendarWeekdayView.weekdayLabels[4].text = "木"
        calenderView.calendarWeekdayView.weekdayLabels[4].textColor = dColor.font
        calenderView.calendarWeekdayView.weekdayLabels[5].text = "金"
        calenderView.calendarWeekdayView.weekdayLabels[5].textColor = dColor.font
        calenderView.calendarWeekdayView.weekdayLabels[6].text = "土"
        calenderView.calendarWeekdayView.weekdayLabels[6].textColor = .blue
        
        loadEvent(selectedDate)
        let tmpCalendar = Calendar(identifier: .gregorian)
        currentMonth = tmpCalendar.component(.month, from: Date())
    }
    
    @objc func onClick(){ let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let SecondController = storyboard.instantiateViewController(withIdentifier: "Insert")
        present(SecondController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(eventList.count,1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.backgroundColor = .clear
        if(eventList.count == 0){
            cell.textLabel?.text = "予定はありません"
            cell.textLabel?.textColor = dColor.opening
        }
        else{
            cell.textLabel?.text = eventList[indexPath.row].event
            cell.textLabel?.textColor = dColor.font
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.backgroundColor = .none
        if(eventList.count != 0){
            let alertController = UIAlertController(title: "確認", message: "このイベントを削除しますか？", preferredStyle: .actionSheet)
            let alertOkAction = UIAlertAction(title: "削除", style: .destructive) { (action) in
                
                do {
                    let realm = try! Realm()
                    let object = NCMBObject(className: "ScheduleStudent", objectId: self.eventList[indexPath.row].id)
                    object?.deleteInBackground({ (error) in
                        if error != nil{
                            self.showOkAlert(title: "Error", message: error!.localizedDescription)
                        }
                    })
                    try realm.write {
                        realm.delete(self.eventList[indexPath.row])
                    }
                } catch {
                    print("delete data error.")
                }
                
                alertController.dismiss(animated: true, completion: nil)
                self.loadEvent(self.selectedDate)
            }
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
                alertController.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(alertOkAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
        self.tableView.reloadData()
    }
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    // 祝日判定を行い結果を返すメソッド
    func judgeHoliday(_ date : Date) -> Bool {
        //祝日判定用のカレンダークラスのインスタンス
        let tmpCalendar = Calendar(identifier: .gregorian)
        
        // 祝日判定を行う日にちの年、月、日を取得
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        
        let holiday = CalculateCalendarLogic()
        
        return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
    }
    
    // date型 -> 年月日をIntで取得
    func getDay(_ date:Date) -> (Int,Int,Int){
        let tmpCalendar = Calendar(identifier: .gregorian)
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        return (year,month,day)
    }
    
    //曜日判定
    func getWeekIdx(_ date: Date) -> Int{
        let tmpCalendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday, from: date)
    }
    
    // 土日や祝日の日の文字色を変える
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let tmpCalendar = Calendar(identifier: .gregorian)
        let inputMonth = tmpCalendar.component(.month, from: date)
        if(inputMonth == currentMonth){
            //祝日判定をする
            if self.judgeHoliday(date){
                return UIColor(iRed: 255, iGreen: 0, iBlue: 0)
            }
            
            //土日の判定
            let weekday = self.getWeekIdx(date)
            if weekday == 1 {
                return UIColor(iRed: 255, iGreen: 0, iBlue: 0)
            }
            else if weekday == 7 {
                return UIColor(iRed: 0, iGreen: 0, iBlue: 255)
            }
            else{
                return dColor.font
            }
        }
        else{
            //祝日判定をする
            if self.judgeHoliday(date){
                return UIColor(iRed: 255, iGreen: 127, iBlue: 127)
            }
            
            //土日の判定
            let weekday = self.getWeekIdx(date)
            if weekday == 1 {
                return UIColor(iRed: 255, iGreen: 127, iBlue: 127)
            }
            else if weekday == 7 {
                return UIColor(iRed: 127, iGreen: 192, iBlue: 255)
            }
            else{
                return nil
            }
        }
    }
    
    func loadEvent(_ date: Date) {
        //予定がある場合、スケジュールをDBから取得・表示する。
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let da = formatter.string(from: date)
        datelabel.text = da
        
        switch getWeekIdx(date) {
        case 1:
            datelabel.textColor = .red
        case 7:
            datelabel.textColor = .blue
        default:
            datelabel.textColor = .black
        }
        if(judgeHoliday(date)){
            datelabel.textColor = .red
        }
        
        //スケジュール取得
        let realm = try! Realm()
        var result = realm.objects(Event.self)
        result = result.filter("date = '\(da)'")
        eventList = []
        for ev in result {
            if ev.date == da {
                eventList.append(ev)
            }
        }
        tableView.reloadData()
    }
    
    //カレンダー処理(スケジュール表示処理)
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition){
        let tmpCalendar = Calendar(identifier: .gregorian)
        let inputMonth = tmpCalendar.component(.month, from: date)
        if(currentMonth != inputMonth){
            calenderView.setCurrentPage(date, animated: true)
        }
        selectedDate = date
        loadEvent(selectedDate)
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let da = formatter.string(from: date)
        let realm = try! Realm()
        var result = realm.objects(Event.self)
        result = result.filter("date = '\(da)'")
        if result.count != 0 {
            return 1
        }else{
            return 0
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let tmpCalendar = Calendar(identifier: .gregorian)
        currentMonth = tmpCalendar.component(.month, from: calendar.currentPage)
        calenderView.reloadData()
    }
    
}


