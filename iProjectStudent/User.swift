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
    
    var ncmb: NCMBUser
    var userId: String
    var userName: String
    var userIdFurigana: String?
    var mailAddress: String?
    var imageName: String?
    var oneOnOneSerch: String
    var teacherParameter: TeacherParameter?
    var studentParameter: StudentParameter?
    
    
    init(_ user: NCMBUser) {
        
        self.ncmb = user
        self.userId = user.objectId
        self.mailAddress = user.mailAddress
        self.userIdFurigana = user.object(forKey: "furigana") as? String
        self.userName = user.object(forKey: "name") as? String ?? "a"
        self.imageName = user.object(forKey: "imageName") as? String
        
        //        個人チャットを検索するためのパラメータ
        if (NCMBUser.current()?.objectId)! < self.userId {
            oneOnOneSerch = (NCMBUser.current()?.objectId)! + "-" + self.userId
        }
        else{
            oneOnOneSerch = self.userId + "-" + (NCMBUser.current()?.objectId)!
        }
        
        //        ユーザの詳細データ
        let parameter = user.object(forKey: "parameter") as? NCMBObject
        if parameter == nil {
            userImagesCacheG[self.userId] = UIImage(named: "studentNoImage.png")
        } else {
            let param = NCMBObject(className: parameter!.ncmbClassName, objectId: parameter!.objectId)
            var error: NSError? = nil
            param?.fetch(&error)
            
            if(error == nil && param != nil){
                let isPermitted = param?.object(forKey: "isPermitted") as? Bool ?? true
                if(isPermitted){
                    if(param!.ncmbClassName == "TeacherParameter"){
                        self.teacherParameter = TeacherParameter(param!)
                        if(userImagesCacheG[self.userId] == nil){
                            userImagesCacheG[self.userId] = UIImage(named: "teacherNoImage.png")
                        }
                    }
                    else{
                        self.studentParameter = StudentParameter(param!)
                        if(userImagesCacheG[self.userId] == nil){
                            userImagesCacheG[self.userId] = UIImage(named: "studentNoImage.png")
                        }
                    }
                }
            }
        }
        //        画像の設定　　
        let imageName = user.object(forKey: "imageName") as? String
        if( imageName != nil ){
            let file = NCMBFile.file(withName: imageName!, data: nil) as! NCMBFile
            file.getDataInBackground { (data, error) in
                if error == nil {
                } else {
                    if data != nil {
                        let image = UIImage(data: data!)
                        userImagesCacheG[self.userId] = image
                    }
                }
            }
        }
    }
    
    convenience init(_ user: NCMBUser, score: Double){
        self.init(user)
        self.teacherParameter!.score = score
    }
}


class TeacherParameter{
    
    var ncmb: NCMBObject
    var objectId: String
    var departments: String
    var score: Double

    
    init(_ parameter: NCMBObject) {
        
        self.ncmb = parameter
        self.objectId = parameter.objectId
        self.departments = parameter.object(forKey: "departments") as? String ?? ""
        self.score = 0.d// 一旦これで
    }
}

class StudentParameter{
    
    var ncmb: NCMBObject
    var choice: String
    var objectId: String
    var SchoolName: String
    var selection: String
    var grade: String
    var parentEmailAdress: String
    var introduction: String
    var youbi: String
    var personalityGroup: Int
    var teacherGrades: [String]
    
    init(_ parameter: NCMBObject) {
        
        self.ncmb = parameter
        self.objectId = parameter.objectId
        self.choice = parameter.object(forKey: "choice") as? String ?? ""
        self.SchoolName = parameter.object(forKey: "SchoolName") as? String ?? ""
        self.selection = parameter.object(forKey: "selection") as? String ?? ""
        self.grade = parameter.object(forKey: "grade") as? String ?? ""
        self.choice = parameter.object(forKey: "choice") as? String ?? ""
        self.parentEmailAdress = parameter.object(forKey: "parentEmailAdress") as? String ?? ""
        self.introduction = parameter.object(forKey: "introduction") as? String ?? ""
        self.youbi = parameter.object(forKey: "youbi") as? String ?? ""
        self.personalityGroup = parameter.object(forKey: "personalityGroup") as? Int ?? -1
        self.teacherGrades = parameter.object(forKey: "teacherGrades") as? [String] ?? []
    }
}
