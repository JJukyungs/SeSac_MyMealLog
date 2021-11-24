//
//  SliderStar.swift
//  SeSac_MyMealLog
//
//  Created by 이주경 on 2021/11/25.
//

import UIKit

class SliderStar: UISlider {

 
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        let width = self.frame.size.width
        let tapPoint = touch.location(in: self)
        let fPercent = tapPoint.x/width
        let nNewValue = self.maximumValue * Float(fPercent)
        
        if nNewValue != self.value {
            self.value = nNewValue
        }
        return true
    }

}
