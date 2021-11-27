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
    @Persisted var date : String
    @Persisted var contentText : String?
    @Persisted var ratingStar : String
    @Persisted var location : String?
    
    // PK
    @Persisted(primaryKey: true) var _id: ObjectId
    
    convenience init(restaurantTitle: String, date: String, content: String?, ratingStar: String, location: String?) {
        self.init()
        
        self.restaurantTitle = restaurantTitle
        self.date = date
        self.contentText = content
        self.ratingStar = ratingStar
        self.location = location
    }
    
}
