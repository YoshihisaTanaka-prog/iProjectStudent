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
//    var isTeacher: Bool
    var oneOnOneSerch: String
    var teacherParameter: TeacherParameter?
    var studentParameter: StudentParameter?
    
    
    init(_ user: NCMBUser) {
        
        self.ncmb = user
        self.userId = user.objectId
        self.mailAddress = user.mailAddress
        self.userIdFurigana = user.object(forKey: "furigana") as? String
        self.userName = user.object(forKey: "userName") as! String
//        self.isTeacher = user.object(forKey: "isTeacher") as! Bool
        
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
            self.userName = ""
            user.userName = ""
            var e: NSError? = nil
            user.save(&e)
        } else {
            let param = NCMBObject(className: parameter!.ncmbClassName, objectId: parameter!.objectId)
            var error: NSError? = nil
            param?.fetch(&error)
            
            if(error == nil && param != nil){
                if(param!.ncmbClassName == "teacherParameter"){
                    self.teacherParameter = TeacherParameter(param!)
                    userImagesG[self.userId] = UIImage("teacherNoImage.png")
                }
                else{
                    self.studentParameter = StudentParameter(param!)
                    userImagesG[self.userId] = UIImage("studentNoImage.png")
                }
            }
            /*
             //2021/02/23修正
             if(error == nil && param != nil){
                             if(param!.ncmbClassName == "teacherParameter"){
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

             */
        }

        
//        画像の設定
        let imageName = user.object(forKey: "imageName") as? String
        if( imageName != nil ){
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
    
    convenience init(_ parameter: NCMBObject, subject: String){
        let user = parameter.object(forKey: "user") as! NCMBUser
        self.init(user)
        self.teacherParameter = TeacherParameter(parameter)
    }
}

class TeacherParameter{
    
    var ncmb: NCMBObject
    var objectId: String
    var departments: String
    var score: Double?
    
    init(_ parameter: NCMBObject) {
        func fillS(_ s: String?) -> String{
            if s == nil {
                return ""
            }
            else{
                return s!
            }
        }
        func fillD(_ d: Double?) -> Double{
            if d == nil {
                return 0.d
            }
            else{
                return d!
            }
        }
        func fillI(_ i: Int?) -> Int{
            if i == nil {
                return 0
            }
            else{
                return i!
            }
        }
        
        self.ncmb = parameter
        self.objectId = parameter.objectId
        self.departments = fillS(parameter.object(forKey: "departments") as? String)
        self.score = 0.d// 一旦これで
    }
}

class StudentParameter{
    
    var ncmb: NCMBObject
    var objectId: String
    var SchoolName: String
    var selection: String
    var grade: String
    var choice: String
    var parentEmailAdress: String
    var introduction: String
    
    init(_ parameter: NCMBObject) {
        func fillS(_ s: String?) -> String{
            if s == nil {
                return ""
            }
            else{
                return s!
            }
        }
        func fillD(_ d: Double?) -> Double{
            if d == nil {
                return 0.d
            }
            else{
                return d!
            }
        }
        func fillI(_ i: Int?) -> Int{
            if i == nil {
                return 0
            }
            else{
                return i!
            }
        }
        
        self.ncmb = parameter
        self.objectId = parameter.objectId
        self.SchoolName = fillS(parameter.object(forKey: "SchoolName") as? String)
        self.selection = fillS(parameter.object(forKey: "selection") as? String)
        self.grade = fillS(parameter.object(forKey: "grade") as? String)
        self.choice = fillS(parameter.object(forKey: "choice") as? String)
        self.parentEmailAdress = fillS(parameter.object(forKey: "parentEmailAdress") as? String)
        
        //ニフクラ上にデータがない場合があるので条件分岐
        self.introduction = fillS(parameter.object(forKey: "introduction") as? String)
    }
}
