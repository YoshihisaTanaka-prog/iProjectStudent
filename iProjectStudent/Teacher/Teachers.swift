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
            var score = 0.0
            let ts = o.object(forKey: subject + "TotalScore") as? Double ?? 0
            let tn = o.object(forKey: subject + "TotalNum") as? Double ?? 0
            
            if(tn == 0){
                o.setObject(0, forKey: subject + "TotalScore")
                o.setObject(0, forKey: subject + "TotalNum")
                o.saveInBackground { error in
                }
            } else {
                score = ts / tn / 2.d
            }
            let u = o.object(forKey: "user") as! NCMBUser
            let q = NCMBUser.query()
            q?.whereKey("objectId", equalTo: u.objectId)
            q?.findObjectsInBackground({ result, error in
                if(error == nil){
                    DispatchQueue.main.async {
                        let user = result!.first as! NCMBUser
                        self.list.append( User(user, score: score) )
                    }
                }
            })
        }
    }
    
    func sort() {
        // listを並び替える
    }
}
