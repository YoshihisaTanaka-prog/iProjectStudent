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
    var count = 0
    init(){
    }
    
    init(_ objects: [NCMBObject], subject: String) {
        self.list = []
        for o in objects{
            list.append( User(o, subject: subject) )
        }
        self.count = list.count
    }
    
    func sort() {
        // listを並び替える
    }
}
