//
//  RealmModel.swift
//  SeSac_MyMealLog
//
//  Created by 이주경 on 2021/11/24.
//

import Foundation
import RealmSwift
import UIKit

class UserData: Object {
    @Persisted var restaurantTitle : String
    @Persisted var date : String
    @Persisted var contentText : String?
    @Persisted var ratingStar : String
    @Persisted var location : String?
    @Persisted var foodImageCount : Int
    
    
    // PK
    @Persisted(primaryKey: true) var _id: ObjectId
    
    convenience init(restaurantTitle: String, date: String, content: String?, ratingStar: String, location: String?, foodImageCount: Int) {
        self.init()
        
        self.restaurantTitle = restaurantTitle
        self.date = date
        self.contentText = content
        self.ratingStar = ratingStar
        self.location = location
        self.foodImageCount = foodImageCount
    }
    
}
