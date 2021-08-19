//
//  Schedule.swift
//  iProjectTeacher
//
//  Created by 田中義久 on 2021/07/03.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import Foundation
import NCMB

protocol LectureDelegate {
    func savedLecture()
}

class Lecture {
    var delegate: LectureDelegate?
    
    var ncmb: NCMBObject
    var student: User
    var teacher: User
    var timeList: [Date]
    var subject: String
    var subjectName: String
    var detail: String
    var teacherAttendanceTime = 0
    var studentAttendanceTime = 0
    var isAbleToEdit: Bool
    
//    読み取り用
    init(lecture: NCMBObject, _ vc: UIViewController){
        ncmb = lecture
        timeList = lecture.object(forKey: "timeList") as! [Date]
        subject = lecture.object(forKey: "subject") as! String
        subjectName = vc.transformSubject(subject)
        detail = lecture.object(forKey: "detail") as? String ?? ""
        
        let studentId = ncmb.object(forKey: "studentId") as! String
        let teacherId = ncmb.object(forKey: "teacherId") as! String
//        コピペ時注意
        isAbleToEdit = false
        
        teacher = User(userId: teacherId, isNeedParameter: true, viewController: vc)
        student = User(userId: studentId, isNeedParameter: true, viewController: vc)
    }
    
    func save(_ vc: UIViewController){
        let object = self.ncmb
        object.setObject(timeList, forKey: "timeList")
        object.setObject(subject, forKey: "subject")
        object.setObject(detail, forKey: "detail")
        object.saveInBackground { error in
            if error != nil{
                vc.showOkAlert(title: "Uploading data error", message: error!.localizedDescription)
            }
        }
    }
    
}

//コマ生成用
extension Lecture{
    func timeFrame(date: Date, teacherId: String) -> [String: [TimeFrameUnit]]{
        var ret = [String:[TimeFrameUnit]]()
        let c = Calendar(identifier: .gregorian)
        let firstDate = c.date(from: DateComponents(year: date.y, month: date.m, day: 1))!
        let lastDate = c.date(from: DateComponents(year: date.y, month: date.m + 1, day: 1))!
        for time in self.timeList{
            if firstDate <= time && time < lastDate {
                if ret[time.d.s] == nil{
                    ret[time.d.s] = []
                }
//                コピペ時注意＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
                if self.student.userId == currentUserG.userId && self.teacher.userId == teacherId {
                    let t1 = TimeFrameUnit(time: time.h, title: self.subjectName, isAbleToShow: true, isMyEvent: false)
                    t1.lectureId = self.ncmb.objectId
                    t1.eventType = "telecture"
                    ret[time.d.s]!.append(t1)
                    let t2 = TimeFrameUnit(time: time.h, title: self.subjectName, isAbleToShow: true, isMyEvent: true)
                    t2.lectureId = self.ncmb.objectId
                    t2.eventType = "telecture"
                    ret[time.d.s]!.append(t2)
                } else if self.student.userId == currentUserG.userId{
                    let t2 = TimeFrameUnit(time: time.h, title: self.subjectName, isAbleToShow: true, isMyEvent: true)
                    t2.lectureId = self.ncmb.objectId
                    t2.eventType = "telecture"
                    ret[time.d.s]!.append(t2)
                } else {
                    let t2 = TimeFrameUnit(time: time.h, title: self.subjectName, isAbleToShow: false, isMyEvent: false)
                    t2.lectureId = self.ncmb.objectId
                    t2.eventType = "telecture"
                    ret[time.d.s]!.append(t2)
                }
            }
        }
        return ret
    }
}


class LectureTimeObject{
    let id: String
    let startTime: Date
    let endTime: Date
    init(id: String, startTime: Date){
        self.id = id
        self.startTime = startTime
        let c = Calendar(identifier: .gregorian)
        endTime = c.date(from: DateComponents(year: startTime.y, month: startTime.m, day: startTime.d, hour: startTime.h + 1, minute: startTime.min))!
    }
}
