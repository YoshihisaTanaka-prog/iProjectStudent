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
            var score = o.object(forKey: subject + "AverageScore") as? Double
            if(score == nil){
                o.setObject(0, forKey: subject + "AverageScore")
                o.setObject(0, forKey: subject + "TotalScore")
                o.setObject(0, forKey: subject + "TotalNum")
                var e: NSError? = nil
                o.save(&e)
                score = 0.d
            }
            let u = o.object(forKey: "user") as! NCMBUser
            let q = NCMBUser.query()
            q?.whereKey("objectId", equalTo: u.objectId)
            q?.findObjectsInBackground({ result, error in
                if(error == nil){
                    DispatchQueue.main.async {
                        let user = result!.first as! NCMBUser
                        self.list.append( User(user, score: score!) )
                    }
                }
            })
        }
    }
    
    func sort() {
        // listを並び替える
    }
}


class niseTeacher {
    var name: String
    var collage: String
    var grade: Int
    var score: Double
    init(_ name: String, _ collage: String, _ grade: Int, _ score: Double){
        self.name = name
        self.collage = collage
        self.grade = grade
        self.score = score
    }
 
}

