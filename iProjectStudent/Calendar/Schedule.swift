//
//  Schedule.swift
//  iProjectTeacher
//
//  Created by 田中義久 on 2021/07/03.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import Foundation
import NCMB

protocol ScheduleClassDelegate {
    func savedSchedule()
}

class Schedule{
    
    var delegate: ScheduleClassDelegate?
    
    var ncmb: NCMBObject
    
    var title: String
    var detail: String
    var eventType: String
    var isAbleToShow: Bool
    var userId: String
    var detailTimeList: [[Date]]
    
    init(schedule: NCMBObject) {
        ncmb = schedule
        title = schedule.object(forKey: "title") as! String
        detail = schedule.object(forKey: "detail") as? String ?? ""
        eventType = schedule.object(forKey: "eventType") as! String
        self.userId = schedule.object(forKey: "userId") as! String
        let iATS = schedule.object(forKey: "isAbleToShow") as! Bool
        isAbleToShow = iATS
        detailTimeList = schedule.object(forKey: "detailTimeList") as! [[Date]]
    }
    
    init(title: String, detail: String, eventType: String, detailTimeList: [[Date]], isAbleToShow: Bool, _ vc: UIViewController){
        ncmb = NCMBObject(className: "Schedule")!
        
        self.title = title
        self.detail = detail
        self.eventType = eventType
        self.userId = currentUserG.userId
        self.isAbleToShow = isAbleToShow
        self.detailTimeList = detailTimeList
        save(vc)
    }
}

//データのアップロード用
extension Schedule{
    func save(_ vc: UIViewController){
        ncmb.setObject(title, forKey: "title")
        ncmb.setObject(detail, forKey: "detail")
        ncmb.setObject(eventType, forKey: "eventType")
        ncmb.setObject(userId, forKey: "userId")
        ncmb.setObject(isAbleToShow, forKey: "isAbleToShow")
        ncmb.setObject(detailTimeList, forKey: "detailTimeList")
        ncmb.setObject(detailTimeList.first?.first , forKey: "startTime")
        ncmb.setObject(detailTimeList.last?.last , forKey: "endTime")
        if detailTimeList.count != 0{
            for detailTime in detailTimeList{
                if(detailTime.count != 2){
                    return
                }
                if(detailTime[0] >= detailTime[1]){
                    return
                }
            }
            ncmb.saveInBackground { error in
                if error == nil{
                    self.delegate?.savedSchedule()
                } else{
                    vc.showOkAlert(title: "Saving message error!", message: error!.localizedDescription)
                }
            }
        }
    }
}

//コマ生成用
extension Schedule{
    func timeFrame(date: Date) -> [String:[TimeFrameUnit]]{
        var ret = [String:[TimeFrameUnit]]()
        let c = Calendar(identifier: .gregorian)
        let startMonth = c.date(from: DateComponents(year: date.y, month: date.m, day: 1))!
        let endMonth = c.date(from: DateComponents(year: date.y, month: date.m + 1, day: 1))!
        func isNeedToFinishLoop(date: Date, end: Date) -> Bool{
            let d = c.date(from: DateComponents(year: date.y, month: date.m, day: date.d, hour: date.h + 1))!
            return d >= end
        }
        for times in self.detailTimeList{
            if(times[0] < endMonth && times[1] >= startMonth){
                var d = times[0]
                let end = times[1]
                while d < endMonth {
                    if d >= startMonth{
                        if ret[d.d.s] == nil{
                            ret[d.d.s] = []
                        }
                        let range = TimeRange(first: businessHoursG[d.weekId].first, last: businessHoursG[d.weekId].last)
                        let startHour = c.date(from: DateComponents(year: d.y, month: d.m, day: d.d, hour: range.first))!
                        let endHour = c.date(from: DateComponents(year: d.y, month: d.m, day: d.d, hour: range.last))!
                        if startHour <= d && d < endHour{
                            if isNeedToFinishLoop(date: d, end: end){
                                if d == times[0]{
                                    let t = TimeFrameUnit(firstHour: d.h, firstMinute: d.m, lastHour: end.h, lastMinute: end.m, title: self.title, isAbleToShow: self.isAbleToShow, isMyEvent: self.userId == currentUserG.userId)
                                    t.eventType = self.eventType
                                    t.scheduleIds.append(self.ncmb.objectId)
                                    ret[d.d.s]!.append(t)
                                    
                                } else{
                                    let t = TimeFrameUnit(firstHour: d.h, firstMinute: 0, lastHour: end.h, lastMinute: end.m, title: self.title, isAbleToShow: self.isAbleToShow, isMyEvent: self.userId == currentUserG.userId)
                                    t.eventType = self.eventType
                                    t.scheduleIds.append(self.ncmb.objectId)
                                    ret[d.d.s]!.append(t)
                                }
                                break
                            } else{
                                if d == times[0]{
                                    let t = TimeFrameUnit(firstHour: d.h, firstMinute: d.m, lastHour: d.h + 1, lastMinute: 0, title: self.title, isAbleToShow: self.isAbleToShow, isMyEvent: self.userId == currentUserG.userId)
                                    t.eventType = self.eventType
                                    t.scheduleIds.append(self.ncmb.objectId)
                                    ret[d.d.s]!.append(t)

                                } else{
                                    let t = TimeFrameUnit(firstHour: d.h, firstMinute: 0, lastHour: d.h + 1, lastMinute: 0, title: self.title, isAbleToShow: self.isAbleToShow, isMyEvent: self.userId == currentUserG.userId)
                                    t.eventType = self.eventType
                                    t.scheduleIds.append(self.ncmb.objectId)
                                    ret[d.d.s]!.append(t)
                                }
                                d = c.date(byAdding: .hour, value: 1, to: d)!
                            }
                        } else if d >= endHour{
                            d = c.date(from: DateComponents(year: d.y, month: d.m, day: d.d + 1, hour: businessHoursG[(d.weekId + 1) % 7].first))!
                            if d > end{
                                break
                            }
                        } else{
                            d = c.date(byAdding: .hour, value: 1, to: d)!
                        }
                    }
                }
            }
        }
        return ret
    }
    
}