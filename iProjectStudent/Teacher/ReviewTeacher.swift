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
    var studentId: String
    var teacherId: String
    var score: Double
    var comment: String
    var title: String
    var subject: String

    init (_ review:NCMBObject){
        self.ncmb = review
        self.studentId = review.object(forKey: "studentId") as? String ?? ""
        self.teacherId = review.object(forKey: "teacherId") as? String ?? ""
        self.score = review.object(forKey: "score") as! Double
        self.comment = review.object(forKey: "comment")as? String ?? ""
        self.title = review.object(forKey: "title") as! String
        self.subject = review.object(forKey: "subject") as? String ?? ""
    }
    
}
    
