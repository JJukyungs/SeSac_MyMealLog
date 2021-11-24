//
//  RealmModel.swift
//  SeSac_MyMealLog
//
//  Created by 이주경 on 2021/11/24.
//

import Foundation
import RealmSwift

class UserData: Object {
    @Persisted var restaurantTitle : String
    @Persisted var date = Date()
    @Persisted var content : String?
    @Persisted var ratingStar : Double
    
    // PK
    @Persisted(primaryKey: true) var _id: ObjectId
    
    convenience init(restaurantTitle: String, date: Date, content: String?, ratingStar: Double) {
        self.init()
        
        self.restaurantTitle = restaurantTitle
        self.date = date
        self.content = content
        self.ratingStar = ratingStar
    }
    
}
