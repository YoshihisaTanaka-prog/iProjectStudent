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
    var userName = ""
    var furigana = ""
    var grade = "0"
    var mailAddress = ""
    var oneOnOneSerch: String
    var selection = ""
    var introduction = ""
    var youbiTimeList: [[String]] = []
    var teacherParameter: TeacherParameter?
    var studentParameter: StudentParameter?
    
    
    init(userId: String, isNeedParameter: Bool, viewController: UIViewController) {
        
        self.userId = userId
        
        //        個人チャットを検索するためのパラメータ
        if (NCMBUser.current()?.objectId)! < self.userId {
            oneOnOneSerch = (NCMBUser.current()?.objectId)! + "-" + self.userId
        }
        else{
            oneOnOneSerch = self.userId + "-" + (NCMBUser.current()?.objectId)!
        }
        
        //        ユーザの詳細データ
        if isNeedParameter{
            let query1 = NCMBQuery(className: "TeacherParameter")
            query1?.whereKey("userId", equalTo: self.userId)
            query1?.findObjectsInBackground({ result, error in
                if error == nil{
                    if(result!.count > 0){
                        let param = result!.first! as! NCMBObject
                        self.teacherParameter = TeacherParameter(param, userId: self.userId, userName: &self.userName, furigana: &self.furigana, grade: &self.grade, selection: &self.selection, introduction: &self.introduction, youbiTimeList: &self.youbiTimeList)
                    }
                } else {
                    viewController.showOkAlert(title: "Error", message: error!.localizedDescription)
                }
            })
            let query2 = NCMBQuery(className: "StudentParameter")
            query2?.whereKey("userId", equalTo: self.userId)
            query2?.findObjectsInBackground({ result, error in
                if error == nil{
                    if(result!.count > 0){
                        let param = result!.first! as! NCMBObject
                        self.studentParameter = StudentParameter(param, userId: self.userId, userName: &self.userName, furigana: &self.furigana, grade: &self.grade, selection: &self.selection, introduction: &self.introduction, youbiTimeList: &self.youbiTimeList)
                    }
                } else {
                    viewController.showOkAlert(title: "User Class Error", message: error!.localizedDescription)
                }
            })
        }
    }
    
    convenience init(_ user: NCMBUser) {
        self.init(userId: user.objectId, isNeedParameter: true, viewController: ViewController())
    }
    
}

class Parameter{
    var ncmb: NCMBObject
    init(_ parameter: NCMBObject){
        self.ncmb = parameter
        
        let imageName = parameter.object(forKey: "imageName") as? String
        let userId = parameter.object(forKey: "userId") as! String
        
        
        if userImagesCacheG[userId] == nil{
            if imageName == nil {
                setNoImage(userId)
            } else {
                let file =  NCMBFile.file(withName: userId,data:nil) as! NCMBFile
                file.getDataInBackground { (data, error) in
                    if error == nil {
                        if data == nil {
                            self.setNoImage(userId)
                        } else {
                            let image = UIImage(data: data!)
                            userImagesCacheG[userId] = image
                        }
                    } else {
                        self.setNoImage(userId)
                    }
                }
            }
        }
    }
    
    private func setNoImage(_ userId: String){
        if self.ncmb.ncmbClassName == "TeacherParameter" {
            userImagesCacheG[userId] = UIImage(named: "teacherNoImage.png")
        } else {
            userImagesCacheG[userId] = UIImage(named: "studentNoImage.png")
        }
    }
    
    func setUserFromProperties(userId: String, userName: inout String, furigana: inout String, grade: inout String, selection: inout String, introduction: inout String, youbiTimeList: inout [[String]]){
        userName = ncmb.object(forKey: "userName") as! String
        furigana = ncmb.object(forKey: "furigana") as! String
        grade = ncmb.object(forKey: "grade") as! String
        selection = ncmb.object(forKey: "selection") as! String
        introduction = ncmb.object(forKey: "introduction") as! String
        let youbiList = ["Monday","Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        for y in youbiList{
            let youbi = ncmb.object(forKey: y + "Time") as? [String] ?? []
            youbiTimeList.append(youbi)
        }
    }
    
    func setUser(user: inout User){
        setUserFromProperties(userId: user.userId, userName: &user.userName, furigana: &user.furigana, grade: &user.grade, selection: &user.selection, introduction: &user.introduction, youbiTimeList: &user.youbiTimeList)
    }
    
}

class TeacherParameter: Parameter{
    
    var score = 0.d
    var subjectNum = 0
    var collage: String
    var totalNum = 0
    
    override init(_ parameter: NCMBObject){
        print("teacher")
        
        self.collage = parameter.object(forKey: "collage") as? String ?? ""
        
        let subjectList = [
            ["modernWriting","ancientWiting","chineseWriting"],
            ["math1a","math2b","math3c"],
            ["physics","chemistry","biology","earthScience"],
            ["geography","japaneseHistory","worldHistory","modernSociety","ethics","politicalScienceAndEconomics"],
            ["hsEnglish"]
        ]
        for sList in subjectList{
            for s in sList{
                let num = parameter.object(forKey: s + "TotalNum") as? Int ?? 0
                totalNum += num
            }
        }
        super.init(parameter)
    }
    
    convenience init(_ parameter: NCMBObject, userId: String, userName: inout String, furigana: inout String, grade: inout String, selection: inout String, introduction: inout String, youbiTimeList: inout [[String]]) {
        self.init(parameter)
        setUserFromProperties(userId: userId, userName: &userName, furigana: &furigana, grade: &grade, selection: &selection, introduction: &introduction, youbiTimeList: &youbiTimeList)
    }
    
    convenience init(_ parameter: NCMBObject, user: inout User) {
        self.init(parameter)
        user.teacherParameter = self
        setUser(user: &user)
    }
}

class StudentParameter: Parameter{
    
    var choice: [[String]]
    var schoolName: String
    var parentEmailAdress: String
    var youbi: String
    var personalityGroup: Int
    var teacherGrades: [String]
    
    override init(_ parameter: NCMBObject){
        print("student")
        
        self.choice = parameter.object(forKey: "choice") as? [[String]] ?? [[""]]
        self.schoolName = parameter.object(forKey: "schoolName") as? String ?? ""
        self.parentEmailAdress = parameter.object(forKey: "parentEmailAdress") as? String ?? ""
        self.youbi = parameter.object(forKey: "youbi") as? String ?? "FFFFFFF"
        self.personalityGroup = parameter.object(forKey: "personalityGroup") as? Int ?? -1
        self.teacherGrades = parameter.object(forKey: "teacherGrades") as? [String] ?? []
        
        super.init(parameter)
    }
    
    convenience init(_ parameter: NCMBObject, userId: String, userName: inout String, furigana: inout String, grade: inout String, selection: inout String, introduction: inout String, youbiTimeList: inout [[String]]) {
        self.init(parameter)
        setUserFromProperties(userId: userId, userName: &userName, furigana: &furigana, grade: &grade, selection: &selection, introduction: &introduction, youbiTimeList: &youbiTimeList)
    }
    
    convenience init(_ parameter: NCMBObject, user: inout User) {
        self.init(parameter)
        user.studentParameter = self
        setUser(user: &user)
    }
}
