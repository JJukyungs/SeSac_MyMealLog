//
//  ListViewController.swift
//  SeSac_MyMealLog
//
//  Created by 이주경 on 2021/11/20.
//

import UIKit
import Firebase
import FirebaseAnalytics
import FirebaseCrashlytics



class ListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 오류 구현 코드
        let button = UIButton(type: .roundedRect)
           button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
           button.setTitle("Test Crash", for: [])
           button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
           view.addSubview(button)
        
    }
    @IBAction func crashButtonTapped(_ sender: AnyObject) {
         let numbers = [0]
         let _ = numbers[1]
     }
    
    
    override func viewWillAppear(_ animated: Bool) {
      
        // 회원가입 : 아이디 > 닉네임 > 연락처 > 성별 > 가입 완료
        
//        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
//          AnalyticsParameterItemID: "id-\(title!)",
//          AnalyticsParameterItemName: title!,
//          AnalyticsParameterContentType: "cont",
//        ])
//
        
        Analytics.logEvent("share_image", parameters: [
          "name": "Jack" as NSObject,
          "full_text": "TEST" as NSObject,
        ])
    }

}
