//
//  ReviewTeacher.swift
//  iProjectStudent
//
//  Created by user on 2021/02/11.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import Foundation
import NCMB

class ReviewTeacher{
    var objectId: String
    var studentId: String
    var teacherId: String
    var score: Double
    var comment: String
    var title: String

    init (_ review:NCMBObject){
        self.objectId = review.object(forKey: "objectId") as! String
        self.studentId = review.object(forKey: "studentId") as! String
        self.teacherId = review.object(forKey: "teacherId") as! String
        self.score = review.object(forKey: "Reviewscore") as! Double
        self.comment = review.object(forKey: "Reviewcomment")as! String
        self.title = review.object(forKey: "Reviewcomment")as! String
    }
    
}
    
