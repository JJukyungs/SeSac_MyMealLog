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
    @IBOutlet weak var ratingSlider: UISlider!
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var thridImageView: UIImageView!
    
    //var images = [UIImage]()
    var foodImages = [UIImage]()
    
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
            // 이미지 도큐먼트에 저장
            saveImageToDocumentDirectory(imageName: "\(task._id)_first.png", image: firstImageView.image ?? UIImage())
            saveImageToDocumentDirectory(imageName: "\(task._id)_second.png", image: secondImageView.image ?? UIImage())
            saveImageToDocumentDirectory(imageName: "\(task._id)_thrid.png", image: thridImageView.image ?? UIImage())
            
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
        firstImageView.image = nil
        secondImageView.image = nil
        thridImageView.image = nil
        
        foodImages.removeAll()
        
        for index in 0...5 {
            if let starImage = view.viewWithTag(index) as? UIImageView {
                starImage.image = UIImage(named: "star_empty")
            }
        }
        ratingSlider.value = 0
        
        
        
        print("init")
    }
    
    // 사진 저장
    func saveImageToDocumentDirectory(imageName: String, image: UIImage) {
        // 1. 이미지 저장하기 위한 경로 설정 : 명확하게 설정되어있음. 도큐먼트 폴더!!, FileManager(싱글턴 패턴)
        
        // for:   / in: 정보의 제한
        // Desktop/jack/ios/folder/
        guard let documentDirctory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        // 2. 이미지 파일 이름 & 최종 경로 설정  [매개변수로 파일 이름을 설정을 함]
        // Desktop/jack/ios/folder/222.png
        let imageURL = documentDirctory.appendingPathComponent(imageName)
        
        // 3. 이미지 압축 (image.pngData(), image,jpegData())
        guard let data = image.pngData() else {
            return
        }
       
        
        // 4. 이미지 저장: 동일한 경로에 이미지를 저장하게 될 경우, 덮어쓰기
        // 4 - 1. 이미지 경로 여부 확인
        if FileManager.default.fileExists(atPath: imageURL.path) {
            
            // 4 - 2. 기존 경로에 있는 임지 삭제
            do {
                try FileManager.default.removeItem(at: imageURL)
                print("이미지 삭제")
            } catch {
                print("이미지를 삭제하지 못했습니다.")
            }
        }
        
        // 5. 이미지를 도큐먼트에 저장
        do {
            try data.write(to: imageURL)
        } catch {
            print("이미지 저장 못함!")
        }
        
        
    }
    
    
    // fetch 가져오기
 
    
    
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



// PHPicker

extension AddViewController: PHPickerViewControllerDelegate {
    
        
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        foodImages.removeAll()
        
        picker.dismiss(animated: true)

       
        
        let group = DispatchGroup()
        
        results.forEach { Result in
            group.enter()
            Result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] reading, error in
                defer {
                    group.leave()
                }
                guard let image = reading as? UIImage, error == nil else {
                    return
                }
                self?.foodImages.append(image)
            }
        }
        group.notify(queue: .main) { [self] in
            print(self.foodImages.count)
            
        
            
        
            print("foodImages :\(foodImages)")
            if !foodImages.isEmpty {
                if foodImages.count == 1{
                    firstImageView.image = foodImages[0]
                    print("foodImages[0] : \(foodImages[0])")
                } else if foodImages.count == 2 {
                    firstImageView.image = foodImages[0]
                    secondImageView.image = foodImages[1]
                    print("foodImages[0],[1] : \(foodImages[0]) \(foodImages[1])")
                } else {
                    firstImageView.image = foodImages[0]
                    secondImageView.image = foodImages[1]
                    thridImageView.image = foodImages[2]
                    print("foodImages[0],[1],[2] : \(foodImages[0]) \(foodImages[1]) \(foodImages[2])")
                }
            }
        }
        
    
       
        
//        var imagTagN = 1001
//        for food in foodImages {
//            if let foodImage = self.view.viewWithTag(imagTagN) as? UIImageView {
//                        foodImage.image = food
//                        imagTagN = imagTagN + 1
//
//            }
//        }
   
      
        
//        let itemProvider = results.first?.itemProvider
////        let itemProvdier = results.
//        print("PHPicker : \(itemProvider)")
//        if let itemProvider = itemProvider,
//           itemProvider.canLoadObject(ofClass: UIImage.self) {
//            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
//                DispatchQueue.main.async {
//                    self.image1.image = image as? UIImage
//
//                }
//            }
//        } else {
//            print("picker 에러")
//        }
         
        
//        ikyle.me/blog/2020/phpickerviewcontroller
/*
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
 */
    }
    

    
    
    
    
}
