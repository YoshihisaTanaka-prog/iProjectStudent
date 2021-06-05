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
    var userName: String
    var furigana: String
    var grade: String
    var mailAddress: String
    var imageName: String?
    var oneOnOneSerch: String
    var teacherParameter: TeacherParameter?
    var studentParameter: StudentParameter?
    
    
    init(_ user: NCMBUser) {
        
        self.ncmb = user
        self.mailAddress = user.mailAddress
        self.furigana = ""
        self.userName = ""
        self.grade = ""
        self.imageName = user.object(forKey: "imageName") as? String
        
        //        個人チャットを検索するためのパラメータ
        if (NCMBUser.current()?.objectId)! < self.ncmb.objectId {
            oneOnOneSerch = (NCMBUser.current()?.objectId)! + "-" + self.ncmb.objectId
        }
        else{
            oneOnOneSerch = self.ncmb.objectId + "-" + (NCMBUser.current()?.objectId)!
        }
        
        //        ユーザの詳細データ
        let parameter = user.object(forKey: "parameter") as? NCMBObject
        if parameter == nil {
            userImagesCacheG[self.ncmb.objectId] = UIImage(named: "studentNoImage.png")
        } else {
            let param = NCMBObject(className: parameter!.ncmbClassName, objectId: parameter!.objectId)
            var error: NSError? = nil
            param?.fetch(&error)
            
            if(error == nil && param != nil){
                let isPermitted = param?.object(forKey: "isPermitted") as? Bool ?? true
                if(isPermitted){
                    if(param!.ncmbClassName == "TeacherParameter"){
                        self.teacherParameter = TeacherParameter(param!, userName: &userName, furigana: &furigana, grade: &grade)
                    }
                    else{
                        self.studentParameter = StudentParameter(param!, userName: &userName, furigana: &furigana, grade: &grade)
                    }
                }
            }
        }
        //        画像の設定　　
        let imageName = user.object(forKey: "imageName") as? String
        //　負荷軽減のため、一回しかユーザーの画像はロードしないようにする。
        if( !userImagesCacheG.keys.contains(self.ncmb.objectId) ){
            if( imageName != nil ){
                print("Loading " + self.ncmb.objectId + "'s image")
                let file = NCMBFile.file(withName: imageName!, data: nil) as! NCMBFile
                file.getDataInBackground { (data, error) in
                    if error == nil {
                        if data != nil {
                            let image = UIImage(data: data!)
                            userImagesCacheG[self.ncmb.objectId] = image
                            print("Loaded image")
                        }
                    } else {
                        self.setNoImage()
                    }
                }
            } else{
                setNoImage()
            }
        }
    }
    
    convenience init(_ user: NCMBUser, score: Double){
        self.init(user)
        self.teacherParameter!.score = score
    }
    
    private func setNoImage(){
        if self.teacherParameter == nil{
            userImagesCacheG[self.ncmb.objectId] = UIImage(named: "studentNoImage.png")
        } else {
            userImagesCacheG[self.ncmb.objectId] = UIImage(named: "teacherNoImage.png")
        }
        print("no image")
    }
}


class TeacherParameter{
    
    var ncmb: NCMBObject
    var selection: String
    var introduction: String
    var score: Double
    var collage: String
    

    
    init(_ parameter: NCMBObject, userName: inout String, furigana: inout String, grade: inout String) {
        
        self.ncmb = parameter
        self.selection = parameter.object(forKey: "selection") as? String ?? ""
        self.introduction = parameter.object(forKey: "introduction") as? String ?? ""
        self.score = 0.d// 一旦これで
        self.collage = parameter.object(forKey: "collage") as? String ?? ""
        
        userName = parameter.object(forKey: "userName") as? String ?? ""
        furigana = parameter.object(forKey: "furigana") as? String ?? ""
        grade = parameter.object(forKey: "grade") as? String ?? "0"
    }
}

class StudentParameter{
    
    var ncmb: NCMBObject
    var choice: [[String]]
    var schoolName: String
    var selection: String
    var parentEmailAdress: String
    var introduction: String
    var youbi: String
    var personalityGroup: Int
    var teacherGrades: [String]
    
    init(_ parameter: NCMBObject, userName: inout String, furigana: inout String, grade: inout String) {
        
        self.ncmb = parameter
        self.choice = parameter.object(forKey: "choice") as? [[String]] ?? [[""]]
        self.schoolName = parameter.object(forKey: "schoolName") as? String ?? ""
        self.selection = parameter.object(forKey: "selection") as? String ?? ""
        self.parentEmailAdress = parameter.object(forKey: "parentEmailAdress") as? String ?? ""
        self.introduction = parameter.object(forKey: "introduction") as? String ?? ""
        self.youbi = parameter.object(forKey: "youbi") as? String ?? "FFFFFFF"
        self.personalityGroup = parameter.object(forKey: "personalityGroup") as? Int ?? -1
        self.teacherGrades = parameter.object(forKey: "teacherGrades") as? [String] ?? []
        
        userName = parameter.object(forKey: "userName") as? String ?? ""
        furigana = parameter.object(forKey: "furigana") as? String ?? ""
        grade = parameter.object(forKey: "grade") as? String ?? "0"
    }
}
