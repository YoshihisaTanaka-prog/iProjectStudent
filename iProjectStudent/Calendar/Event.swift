//
//  Event.swift
//  iProjectTeacher
//
//  Created by Ryusei Hiraoka on 2021/02/10.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//
import Foundation
import RealmSwift

class Event: Object {

    @objc dynamic var date: String = ""
    @objc dynamic var event: String = ""
    @objc dynamic var studentId: String = ""
    @objc dynamic var teacherId: String? = ""
    @objc dynamic var kind: String = ""
    @objc dynamic var id: String = ""

}


