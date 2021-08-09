//
//  ReviewTeacher.swift
//  iProjectStudent
//
//  Created by user on 2021/02/11.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import Foundation
import NCMB

class Review{
    var ncmb: NCMBObject
    var student: User
    var teacher: User
    var score: Double
    var comment: String
    var title: String
    var subject: String

    init (_ review:NCMBObject){
        self.ncmb = review
        let studentId = review.object(forKey: "studentId") as? String ?? ""
        self.student = User(userId: studentId, isNeedParameter: true, viewController: UIViewController())
        let teacherId = review.object(forKey: "teacherId") as? String ?? ""
        self.teacher = User(userId: teacherId, isNeedParameter: true, viewController: UIViewController())
        self.score = review.object(forKey: "score") as! Double
        self.comment = review.object(forKey: "comment")as? String ?? ""
        self.title = review.object(forKey: "title") as! String
        self.subject = review.object(forKey: "subject") as? String ?? ""
    }
    
}

