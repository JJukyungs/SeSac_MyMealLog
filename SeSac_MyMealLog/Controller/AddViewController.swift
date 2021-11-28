//
//  AddViewController.swift
//  SeSac_MyMealLog
//
//  Created by 이주경 on 2021/11/19.
//

// 탭바에서 추가 버튼

import UIKit
import RealmSwift
import PhotosUI


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
    
    // 이미지 받아오기
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var imaage3: UIImageView!
    
    
    var imageNameArray: [String] = []
    
    
    
    let datePicekr = UIDatePicker()
    
    // realm 연결
    let localRealm = try! Realm()
    
    // 사용자 앨범에 접근
//    let imagePickercontroller = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Realm 경로 찍기
        print("Realm is located at: ", localRealm.configuration.fileURL!)

        setUI()
        createDatePicekrView()
        
//        imagePickercontroller.delegate = self
    
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
    
    // realm 데이터 삽입
    func saveRealmData() {
        
        let task = UserData(restaurantTitle: restaurantTextField.text!, date: dateTextField.text!, content: contentTextView.text, ratingStar: ratingLabel.text!, location: locationTextField.text)
        
        try! localRealm.write {
            localRealm.add(task)
        }
        print("save")
    }
    
    // 초기화 함수
    func initAddView() {
        restaurantTextField.text = ""
        dateTextField.text = ""
        contentTextView.text = ""
        ratingLabel.text = "0"
        locationTextField.text = ""
        
        print("init")
    }
    
    // MARK: - Action
   
    // 저장 버튼 클릭시 입력받은 데이터가 Realm 으로 넘어감
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "저장하시겠습니까?", message: nil, preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            // alert 창에서
            self.saveRealmData()
            self.initAddView()
            
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: false)
        
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
    
    
    // 카메라 버튼 클릭
    @IBAction func cameraButtonClicked(_ sender: UIButton) {
//        self.imagePickercontroller.sourceType = .photoLibrary
//        self.present(self.imagePickercontroller, animated: true, completion: nil)
        
        
        // PHPicker 사용
        var configuartion = PHPickerConfiguration()
        // 선택할 수 있는 최대 asset 갯수, unlimited = 0
        configuartion.selectionLimit = 3
        configuartion.filter = .images
        
        let picker = PHPickerViewController(configuration: configuartion)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
        
        
    }
}

// 카메라, 앨범 관련 Delegate 연결
//extension AddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            image1.contentMode = .scaleAspectFill
//            image1.image = pickedImage
//        }
//    }
//
//}


// PHPicker

extension AddViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        /*
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
//        let itemProvdier = results.
        print("PHPicker : \(itemProvider)")
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async {
                    self.image1.image = image as? UIImage
                    
                }
            }
        } else {
            print("picker 에러")
        }
         */
        
//        ikyle.me/blog/2020/phpickerviewcontroller
        print(picker)
        print(results)
        
        for result in results {
              result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
                  print(object)
                  print(error)
                 if let image = object as? UIImage {
                    DispatchQueue.main.async {
                       // Use UIImage
                       print("Selected image: \(image)")
                    }
                 }
              })
           }
    }
    

    
    
    
    
}
