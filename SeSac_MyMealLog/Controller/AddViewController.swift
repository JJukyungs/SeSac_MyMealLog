//
//  AddViewController.swift
//  SeSac_MyMealLog
//
//  Created by 이주경 on 2021/11/19.
//

// 탭바에서 추가 버튼

import UIKit
import RealmSwift

class AddViewController: UIViewController {

    
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var restaurantTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var cameraButton: UIButton!
//    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var dateTextField: UITextField!
    
    let datePicekr = UIDatePicker()
    
    // realm 연결
    let localRealm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Realm 경로 찍기
        print("Realm is located at: ", localRealm.configuration.fileURL!)

        
        setUI()
        createDatePicekrView()
    }
    
    // MARK: - Function
    
    func setUI() {
        mainTitleLabel.textAlignment = .center
        // 폰트
        mainTitleLabel.font = UIFont().mainTitleFont
        restaurantTextField.placeholder = String("식당이름 입력")
        
        ratingLabel.font = UIFont().mainTitleFont
        
        saveButton.tintColor = .white
        saveButton.backgroundColor = UIColor.mainRedColor
        saveButton.clipsToBounds = true
        saveButton.layer.cornerRadius = 10
        
        dateTextField.textAlignment = .center
        ratingLabel.text = "0"
    }

    // DatePicker
    func createDatePicekrView() {
        // Toolbar 만들기
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // done 버튼 만들기
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneClicked))
        
        // 버튼 툴바에 할당
        toolbar.setItems([doneButton], animated: true)
        
        // textField 에 toolbar 입히기
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = datePicekr
        
        datePicekr.datePickerMode = .date
        datePicekr.preferredDatePickerStyle = .wheels
    }
    
    @objc func doneClicked() {
        // dateFormatter
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        dateTextField.text = formatter.string(from: datePicekr.date)
        self.view.endEditing(true)
    }
    
    
    
    // MARK: - Action
   
    // 저장 버튼 클릭시 입력받은 데이터가 Realm 으로 넘어감
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        
        let task = UserData(restaurantTitle: restaurantTextField.text!, date: dateTextField.text!, content: contentTextView.text, ratingStar: ratingLabel.text!, location: locationTextField.text)
        
        try! localRealm.write {
            localRealm.add(task)
        }
    
    }
    
    
    // slider
    @IBAction func onDragStarSlider(_ sender: UISlider) {
        let floatValue = floor(sender.value * 10) / 10
        let intValue = Int(floor(sender.value))
        
        // tag 매칭
        for index in 0...5 {
            if let starImage = view.viewWithTag(index) as? UIImageView {
                if index <= intValue / 2 {
                    starImage.image = UIImage(named: "star_full")
                } else {
                    if (2 * index - intValue) <= 1 {
                        starImage.image = UIImage(named: "star_half")
                    } else {
                        starImage.image = UIImage(named: "star_empty")
                    }
                }
            }
            self.ratingLabel?.text = String(Int(floatValue))
        }
    }
}
