//
//  User.swift
//  ChatTest
//
//  Created by 田中義久 on 2021/01/11.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import Foundation
import UIKit
import NCMB

class User {
    var userId: String
    var userName: String
    var userIdFurigana: String?
    var mailAddress: String?
    var isTeacher: Bool
    var oneOnOneSerch: String
    var teacherParameter: TeacherParameter?
    var studentParameter: StudentParameter?
    
    
    init(_ user: NCMBUser) {
        
        self.userId = user.objectId
        self.mailAddress = user.mailAddress
        self.userIdFurigana = user.object(forKey: "furigana") as? String
        self.userName = user.object(forKey: "userName") as! String
        self.isTeacher = user.object(forKey: "isTeacher") as! Bool
        
//        個人チャットを検索するためのパラメータ
        if (NCMBUser.current()?.objectId)! < self.userId {
            oneOnOneSerch = (NCMBUser.current()?.objectId)! + "-" + self.userId
        }
        else{
            oneOnOneSerch = self.userId + "-" + (NCMBUser.current()?.objectId)!
        }
        
//        ユーザの詳細データ
        let parameter = user.object(forKey: "parameter") as! NCMBObject
        let param = NCMBObject(className: parameter.ncmbClassName, objectId: parameter.objectId)
        var error: NSError? = nil
        param?.fetch(&error)
        if(error == nil && param != nil){
            if(param!.ncmbClassName == "teacherParameter"){
                self.teacherParameter = TeacherParameter(param!)
            }
            else{
                self.studentParameter = StudentParameter(param!)
            }
        }
        else{
            fatalError(error!.localizedDescription)
        }
        
//        画像の設定
        let imageUrl = user.object(forKey: "imageURL") as? String
        if( imageUrl != nil ){
            let file = NCMBFile.file(withName: imageUrl!, data: nil) as! NCMBFile
            file.getDataInBackground { (data, error) in
                if error == nil {
                } else {
                    if data != nil {
                        let image = UIImage(data: data!)
                        userImagesG[self.userId] = image
                    }
                }
            }
        }
    }
}

class TeacherParameter{
    
    var objectId: String
    var departments: String
    var score: Double
    
    init(_ parameter: NCMBObject) {
        self.objectId = parameter.objectId
        self.departments = parameter.object(forKey: "departments") as! String
        self.score = 1.d// 一旦これで
    }
}

class StudentParameter{
    
    var objectId: String
    var SchoolName: String
    var selection: String
    var grade: String
    var parentEmailAdress: String
    var introduction: String
    
    init(_ parameter: NCMBObject) {
        self.objectId = parameter.objectId
        self.SchoolName = parameter.object(forKey: "SchoolName") as! String
        self.selection = parameter.object(forKey: "selection") as! String
        self.grade = parameter.object(forKey: "grade") as! String
        self.parentEmailAdress = parameter.object(forKey: "parentEmailAdress") as! String
        self.introduction = parameter.object(forKey: "introduction") as! String
    }
}
