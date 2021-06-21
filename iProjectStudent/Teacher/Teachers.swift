//
//  Teachers.swift
//  iProjectStudent
//
//  Created by 田中義久 on 2021/02/23.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import Foundation
import NCMB

class Teachers {
    var list: [User] = []
    var count: Int{
        return self.list.count
    }
    
    init(){}
    
    init(_ objects: [NCMBObject], subject: String) {
        self.list = []
        for o in objects{
            var score = 0.0
            let ts = o.object(forKey: subject + "TotalScore") as? Double ?? 0
            let tn = o.object(forKey: subject + "TotalNum") as? Int ?? 0
            
            if (tn != 0) {
                score = ts / tn.d / 2.d
            }
            let id = o.object(forKey: "userId") as! String
            let u = User(userId: id, isNeedParameter: false, viewController: UIViewController())
            u.teacherParameter = TeacherParameter(o, userId: id, userName: &u.userName, furigana: &u.furigana, grade: &u.grade, selection: &u.selection, introduction: &u.introduction, youbiTimeList: &u.youbiTimeList)
            u.teacherParameter?.score = score
            u.teacherParameter?.subjectNum = tn
            self.list.append(u)
        }
    }
    
    func sort() {
        // listを並び替える
    }
}
