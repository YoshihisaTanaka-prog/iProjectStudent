//
//  Schedule.swift
//  iProjectStudent
//
//  Created by 田中義久 on 2021/06/15.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import Foundation
import NCMB
import CalculateCalendarLogic

//Telecture専用の授業の詳細
class Lecture{
    var ncmb: NCMBObject
    var student: User?
    var teacher: User?
    var startTime: Date
    var endTime: Date
    var subject: String
    var teacherAttendanceTime: Int
    var studentAttendanceTime: Int
    
    init(_ lecture: NCMBObject, _ startTime: Date, _ vc: UIViewController) {
        self.ncmb = lecture
        self.startTime = startTime
        self.endTime = Calendar.current.date(byAdding: .hour, value: 1, to: self.startTime)!
        subject = ncmb.object(forKey: "subject") as! String
        teacherAttendanceTime = ncmb.object(forKey: "teacherAttendanceTime") as? Int ?? 0
        studentAttendanceTime = ncmb.object(forKey: "studentAttendanceTime") as? Int ?? 0
        
        let studentId = ncmb.object(forKey: "studentId") as! String
        let query1 = NCMBQuery(className: "StudentParameter")
        query1?.whereKey("userId", equalTo: studentId)
        query1?.findObjectsInBackground({ result, error in
            if error == nil {
                let object = result?.first as? NCMBObject
                if object == nil{
                    vc.showOkAlert(title: "Error", message: "生徒が見つかりませんでした。")
                } else {
                    // ここに生徒を登録するコードを書く
                }
            }
            else{
                vc.showOkAlert(title: "Error", message: error!.localizedDescription)
            }
        })
        
        let teacherId = ncmb.object(forKey: "teacherId") as! String
        let query2 = NCMBQuery(className: "TeacherParameter")
        query2?.whereKey("userId", equalTo: teacherId)
        query2?.findObjectsInBackground({ result, error in
            if error == nil {
                let object = result?.first as? NCMBObject
                if object == nil{
                    vc.showOkAlert(title: "Error", message: "教師が見つかりませんでした。")
                } else {
                    // ここに教師を登録するコードを書く
                }
            }
            else{
                vc.showOkAlert(title: "Error", message: error!.localizedDescription)
            }
        })
    }
    
    convenience init(_ lecture: NCMBObject, _ startTime: Date, _ vc: UIViewController, eventName: inout String) {
        self.init(lecture,startTime,vc)
        eventName += vc.transformSubject(self.subject) + ")"
    }
}

//1コマ分のデータ
class Schedule{
    var ncmb: NCMBObject?
    var eventName: String
    var isMyscedule: Bool
    var isAbleToReadDetail: Bool
    var time: Int
    var backgroundColor: UIColor
    var lecture: Lecture?
    
//    ちゃんとした予定が入っている場合のinit
    init(_ schedule : NCMBObject, _ vc: UIViewController){
        self.ncmb = schedule
        
//        自分の予定かどうかを判定する。また、自分の予定なら詳細を読めるようにする。（ちょっとややこしい書き方なので、じっくりと考えてみて。）
        let studentId = ncmb!.object(forKey: "studentId") as! String
        let teacherId = ncmb!.object(forKey: "treacherId") as! String
        self.isAbleToReadDetail = currentUserG.userId == studentId || currentUserG.userId == teacherId
        self.isMyscedule = self.isAbleToReadDetail
        
//        開始時間
        self.time = ncmb!.object(forKey: "time") as! Int
        
        
        let pink = UIColor(iRed: 246, iGreen: 173, iBlue: 198)
        let eventType = ncmb!.object(forKey: "eventType") as! String
        switch eventType {
        case "telecture":
            self.eventName = "TeLecture授業 ("
            self.backgroundColor = dColor.accent
//            教師だった場合は生徒の授業の予定を細かく見ることができる。
            if currentUserG.teacherParameter != nil {
                self.isAbleToReadDetail = true
            }
            let id = ncmb!.object(forKey: "lectureId") as! String
            let object = NCMBObject(className: "Lecture", objectId: id)
            object?.fetchInBackground({ error in
                if error == nil{
                    let ym = self.ncmb!.object(forKey: "time") as! Int
                    let date = self.ncmb!.object(forKey: "date") as! Int
                    let c = Calendar.current
                    self.lecture = Lecture(object!, c.date(from: DateComponents(year: ym/100, month: ym%100, day: date, hour: self.time/100, minute: self.time%100, second: 0))!, vc, eventName: &self.eventName)
                } else{
                    vc.showOkAlert(title: "Error", message: error!.localizedDescription)
                }
            })
        case "school":
            self.eventName = "学校行事"
            self.backgroundColor = pink
        case "rival":
            self.eventName = "他の塾"
            self.backgroundColor = pink
        case "private":
            self.eventName = "私用"
            self.backgroundColor = pink
        case "hope":
            self.eventName = "授業候補日"
            self.backgroundColor = dColor.base
//            教師だった場合は生徒の希望の詳細を見ることができる。
            if currentUserG.teacherParameter != nil {
                self.isAbleToReadDetail = true
            }
        default:
            self.eventName = ""
            self.backgroundColor = UIColor(iRed: 255, iGreen: 255, iBlue: 255)
        }
        
        let eName = ncmb!.object(forKey: "title") as? String ?? ""
        if eName.count != 0 && eventType != "telecture" {
            self.eventName = eName
        }
    }
    
//    空きコマor時間外用のinit
    init(isFree: Bool, isMySchedule: Bool, time: Int) {
        if isFree {
            self.eventName = "空きコマ"
            self.backgroundColor = UIColor(iRed: 255, iGreen: 255, iBlue: 255)
        } else {
            self.eventName = ""
            self.backgroundColor = UIColor(iRed: 60, iGreen: 60, iBlue: 60)
        }
        self.isAbleToReadDetail = false
        self.time = time
        self.isMyscedule = isMySchedule
    }
}

//月毎のデータ
class ScheduleMonth {
//    日付ごとにスケジュールを管理
    var dic: [ String: [Schedule] ] = [:]

    func loadSchedules(_ ym: Int, _ userIds: [String], _ vc: UIViewController){
        var queries = [NCMBQuery]()
        for u in userIds{
            let q1 = NCMBQuery(className: "Schedule")!
            q1.whereKey("studentId", equalTo: u)
            let q2 = NCMBQuery(className: "Schedule")!
            q2.whereKey("teacherId", equalTo: u)
            queries.append(q1)
            queries.append(q2)
        }
        let query = NCMBQuery.orQuery(withSubqueries: queries)
        query?.findObjectsInBackground({ result, error in
            if(error == nil){
                let objects = result as? [NCMBObject] ?? []
//                全スケジュールを日付ごとに分割して保存
                for o in objects{
                    let d = o.object(forKey: "date") as! Int
                    let date = d.s
                    if self.dic[date] == nil {
                        self.dic[date] = [Schedule(o, vc)]
                    } else {
                        self.dic[date]!.append(Schedule(o, vc))
                    }
                }
//                保存したスケジュールを時間ごとに並び替え
                for i in 1...31{
                    let date = i.s
                    if self.dic[date] != nil {
                        self.dic[date]! = self.dic[date]!.sorted(by: {$0.time < $1.time})
                    }
                }
            } else {
                vc.showOkAlert(title: "Error", message: error!.localizedDescription)
            }
        })
    }
    
    func isExistsSchedule(_ day: Int) -> Bool {
        let d = day.s
        if self.dic[d] == nil{
            return false
        }
        for d in self.dic[d]!{
//            生徒の希望ではい予定があったら「予定あり」判定をする。
            if d.backgroundColor != dColor.base {
                return true
            }
        }
        return false
    }
}

class Schedules {
//    月ごとにスケジュールを管理
    var dic: [ String: ScheduleMonth ] = [:]
    func loadSchedules(date: Date, userIds: [String], vc: UIViewController){
//        今月分
        loadScheduleMonth(date, userIds, vc)
//            ±2ヶ月分は保存し、その外はデータが重くならないように削除する。
        self.deleteScheduleMonth(Calendar.current.date(byAdding: .day, value: -3, to: date)!)
        self.deleteScheduleMonth(Calendar.current.date(byAdding: .day, value: 3, to: date)!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.loadScheduleMonth(Calendar.current.date(byAdding: .day, value: 1, to: date)!, userIds, vc)
            self.loadScheduleMonth(Calendar.current.date(byAdding: .day, value: -1, to: date)!, userIds, vc)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.loadScheduleMonth(Calendar.current.date(byAdding: .day, value: 2, to: date)!, userIds, vc)
                self.loadScheduleMonth(Calendar.current.date(byAdding: .day, value: -2, to: date)!, userIds, vc)
            }
        }
    }
    
//    その日に予定が入っているかどうかを判定
    func isExistsSchedule(date: Date) -> Bool {
        let ym = date.y * 100 + date.m
        if dic[ym.s] == nil {
            return false
        }
        return dic[ym.s]!.isExistsSchedule(date.d)
    }
    
//    予定を表示するテーブルビューに対応する形式に変換するための関数
    func scheduleLists(date: Date, users: [User]) -> [[Schedule]]{
        var ret:[[Schedule]] = []
        let ym = date.y * 100 + date.m
        let d = date.d
        let weekId = getWeekId(date)
        for i in businessHoursG[weekId].first..<businessHoursG[weekId].last{
            ret.append([])
            for u in users{
//        isFreeの部分を修正すること。
                let isMySchedule = u.userId == currentUserG.userId
                let schedule = serchTime(self.dic[ym.s]?.dic[d.s], isMySchedule, i*100) ?? Schedule(isFree: true, isMySchedule: isMySchedule, time: i * 100)
                ret[i].append(schedule)
            }
        }
        return ret
    }
    
//    引数の月に入っている予定を読み込むための関数
    private func loadScheduleMonth(_ date: Date, _ userIds: [String], _ vc: UIViewController){
        let ym = date.y * 100 + date.m
        if (dic[ym.s] == nil){
            dic[ym.s] = ScheduleMonth()
            dic[ym.s]!.loadSchedules(ym, userIds, vc)
        }
    }
    
//    引数の月に入っている予定を削除するための関数
    private func deleteScheduleMonth(_ date: Date){
        let ym = date.y * 100 + date.m
        dic[ym.s] = nil
    }
    
    private func serchTime(_ scedules: [Schedule]?, _ isMySchedule: Bool, _ time: Int) -> Schedule? {
        if scedules == nil{
            return nil
        }
        for s in scedules!{
            if s.isMyscedule == isMySchedule && s.time == time{
                return s
            }
        }
        return nil
    }
    
//     祝日判定を行い結果を返すメソッド
    private func judgeHoliday(_ date : Date) -> Bool {
        let holiday = CalculateCalendarLogic()
        return holiday.judgeJapaneseHoliday(year: date.y, month: date.m, day: date.d)
    }
    
//    曜日判定(祝日の場合は日曜日扱い)
    private func getWeekId(_ date: Date) -> Int{
        if(judgeHoliday(date)){
            return 6
        }
        let tmpCalendar = Calendar(identifier: .gregorian)
        let ret = tmpCalendar.component(.weekday, from: date) - 2
//        日曜日の場合は ret が -1 になる
        if ret == -1 {
            return 6
        }
        return ret
    }
    
}
