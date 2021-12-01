//
//  HighlightLabel+Extension.swift
//  SeSac_MyMealLog
//
//  Created by 이주경 on 2021/12/01.
//

// https://github.com/camosss/SSAC/blob/main/ssacMemo/ssacMemo/Extension/HighlightLabel%2BExtension.swift

// iOS 초고수 강호성님 하이라이트 Extenstion 입니다!!

import UIKit

extension UILabel {
    func highlight(searchText: String, color: UIColor = .mainRedColor ?? .red) {
       
        guard let labelText = self.text else { return }
       
        do {
           let mutableString = NSMutableAttributedString(string: labelText)
           let regex = try NSRegularExpression(pattern: searchText, options: .caseInsensitive)
           
           for match in regex.matches(in: labelText, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: labelText.utf16.count)) as [NSTextCheckingResult] {
               mutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: match.range)
           }
          
            self.attributedText = mutableString
            
       } catch {
           print(error)
       }
        
    }
    
}
