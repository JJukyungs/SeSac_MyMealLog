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
    
    @IBOutlet weak var closeButton: UIButton!
    //var images = [UIImage]()
    var foodImages = [UIImage]()
    var images = [String]()
    
    let datePicekr = UIDatePicker()
    
    // realm 연결
    let localRealm = try! Realm()
    
    var tasks: Results<UserData>!
    var searchTasks: UserData?
    
    var tasksRow: Int = 0
    
    var addViewSatus: Bool = true
    var imageSatus: Bool = true
    var searchSet: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Realm 경로 찍기
        print("Realm is located at: ", localRealm.configuration.fileURL!)
        tasks = localRealm.objects(UserData.self)
        
        setUI()
        
        if addViewSatus {
            setSaveUI()
        }else {
            setFixUI()
        }
        createDatePicekrView()
        
//        imagePickercontroller.delegate = self
    
    }
    
    // MARK: - Function
    
    func setUI() {
        mainTitleLabel.textAlignment = .center
        mainTitleLabel.font = UIFont().mainTitleFont
        restaurantTextField.placeholder = String("식당이름 입력")
        ratingLabel.font = UIFont().mainTitleFont
        
        saveButton.tintColor = .white
        saveButton.backgroundColor = UIColor.mainRedColor
        saveButton.clipsToBounds = true
        saveButton.layer.cornerRadius = 10
        
        contentTextView.layer.borderWidth = 2.0
        contentTextView.layer.borderColor = UIColor.mainRedColor?.cgColor
        cameraButton.layer.borderWidth = 2.0
        cameraButton.layer.borderColor = UIColor.mainRedColor?.cgColor
    }
    
    func setSaveUI() {

        ratingLabel.text = "0"

        saveButton.setTitle("저 장", for: .normal)
        closeButton.layer.isHidden = true

    }
    func setFixUI() {
        
        saveButton.setTitle("수 정", for: .normal)
        closeButton.layer.isHidden = false
        
        if searchSet == false {
            
            ratingSlider.value = Float(tasks[tasksRow].ratingStar)!
            restaurantTextField.text = tasks[tasksRow].restaurantTitle
            ratingLabel.text = tasks[tasksRow].ratingStar
            locationTextField.text = tasks[tasksRow].location
            dateTextField.text = tasks[tasksRow].date
            contentTextView.text = tasks[tasksRow].contentText
            
            switch images.count - 1 {
            case 0:
                firstImageView.image = loadImageFromDocumentDirectory(imageName: images[0]) ?? UIImage()
            case 1:
                firstImageView.image = loadImageFromDocumentDirectory(imageName: images[0]) ?? UIImage()
                secondImageView.image = loadImageFromDocumentDirectory(imageName: images[1]) ?? UIImage()
            case 2:
                firstImageView.image = loadImageFromDocumentDirectory(imageName: images[0]) ?? UIImage()
                secondImageView.image = loadImageFromDocumentDirectory(imageName: images[1]) ?? UIImage()
                thridImageView.image = loadImageFromDocumentDirectory(imageName: images[2]) ?? UIImage()
            default:
                return
                
            }
        } else {
            
            ratingSlider.value = Float(searchTasks!.ratingStar)!
            restaurantTextField.text = searchTasks?.restaurantTitle
            ratingLabel.text = searchTasks?.ratingStar
            locationTextField.text = searchTasks?.location
            dateTextField.text = searchTasks?.date
            contentTextView.text = searchTasks?.contentText
            
            switch images.count - 1 {
            case 0:
                firstImageView.image = loadImageFromDocumentDirectory(imageName: images[0]) ?? UIImage()
            case 1:
                firstImageView.image = loadImageFromDocumentDirectory(imageName: images[0]) ?? UIImage()
                secondImageView.image = loadImageFromDocumentDirectory(imageName: images[1]) ?? UIImage()
            case 2:
                firstImageView.image = loadImageFromDocumentDirectory(imageName: images[0]) ?? UIImage()
                secondImageView.image = loadImageFromDocumentDirectory(imageName: images[1]) ?? UIImage()
                thridImageView.image = loadImageFromDocumentDirectory(imageName: images[2]) ?? UIImage()
            default:
                return
                
            }
        }
        

        
        for index in 0...5 {
            if let starImage = view.viewWithTag(index) as? UIImageView {
                if index <= Int(ratingSlider.value) / 2 {
                    starImage.image = UIImage(named: "star_full")
                } else {
                    if (2 * index - Int(ratingSlider.value)) <= 1 {
                        starImage.image = UIImage(named: "star_half")
                    } else {
                        starImage.image = UIImage(named: "star_empty")
                    }
                }
            }
        }
        
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
        
        let task = UserData(restaurantTitle: restaurantTextField.text!, date: dateTextField.text!, content: contentTextView.text, ratingStar: ratingLabel.text!, location: locationTextField.text, foodImageCount: foodImages.count)
        
        try! localRealm.write {
            localRealm.add(task)
            // 이미지 도큐먼트에 저장
            saveImageToDocumentDirectory(imageName: "\(task._id)_first.png", image: firstImageView.image ?? UIImage())
            saveImageToDocumentDirectory(imageName: "\(task._id)_second.png", image: secondImageView.image ?? UIImage())
            saveImageToDocumentDirectory(imageName: "\(task._id)_thrid.png", image: thridImageView.image ?? UIImage())
            
        }
        print("save")
    }
    
    func fixRealmData() {
        
        let tasksUpdate = tasks[tasksRow]
        
        try! localRealm.write {
            tasksUpdate.ratingStar = ratingLabel.text!
            tasksUpdate.restaurantTitle = restaurantTextField.text!
            tasksUpdate.contentText = contentTextView.text
            tasksUpdate.location = locationTextField.text
            tasksUpdate.date = dateTextField.text!
            if imageSatus {
                tasksUpdate.foodImageCount = images.count
            } else {
                tasksUpdate.foodImageCount = foodImages.count
            }
        }
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
    // 사진 불러오기
    func loadImageFromDocumentDirectory(imageName: String) -> UIImage? {
        
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        // 제약조건
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        // 최종 경로
        let path = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let directoryPath = path.first {
            let imageURL = URL(fileURLWithPath: directoryPath).appendingPathComponent(imageName)
            
            return UIImage(contentsOfFile: imageURL.path)
        }
        
        return nil
    }
    
    
    // fetch 가져오기
 
    
    
    // MARK: - Action
   
    // 저장 버튼 클릭시 입력받은 데이터가 Realm 으로 넘어감
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        
        if addViewSatus {
        
            if restaurantTextField.text == "" && dateTextField.text == "" {
                
                let errorAlert = UIAlertController(title: "작성하지 않은 부분이 있습니다.", message: "필수 공간을 채워주세요", preferredStyle: .alert)
                let returnAlert = UIAlertAction(title: "확인", style: .default, handler: nil)
                errorAlert.addAction(returnAlert)
                self.present(errorAlert, animated: false)
                
            } else if restaurantTextField.text != "" && dateTextField.text != "" {
                
                let alert = UIAlertController(title: "저장하시겠습니까?", message: nil, preferredStyle: UIAlertController.Style.alert)
                
                let okAction = UIAlertAction(title: "확인", style: .default) { _ in
                    // alert 창에서
                    self.saveRealmData()
                    self.initAddView()
                    
                    let saveAlert = UIAlertController(title: "저장되었습니다.", message: "홈 화면에서 확인해보세요!", preferredStyle: .alert)
                    let saveOkAlert = UIAlertAction(title: "확인", style: .default, handler: nil)
                    saveAlert.addAction(saveOkAlert)
                    self.present(saveAlert, animated: false)
                }
                
                let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                
                self.present(alert, animated: false)
            }
        } else {
            if restaurantTextField.text == "" && dateTextField.text == "" {
                
                let errorAlert = UIAlertController(title: "작성하지 않은 부분이 있습니다.", message: "필수 공간을 채워주세요", preferredStyle: .alert)
                let returnAlert = UIAlertAction(title: "확인", style: .default, handler: nil)
                errorAlert.addAction(returnAlert)
                self.present(errorAlert, animated: false)
                
            } else if restaurantTextField.text != "" && dateTextField.text != "" {
                
                let alert = UIAlertController(title: "수정하시겠습니까?", message: nil, preferredStyle: UIAlertController.Style.alert)
                
                let okAction = UIAlertAction(title: "확인", style: .default) { _ in
                    // alert 창에서
                    self.fixRealmData()
                    //self.initAddView()
                    
                    let saveAlert = UIAlertController(title: "수정되었습니다.", message: "홈 화면에서 확인해보세요!", preferredStyle: .alert)
                    let saveOkAlert = UIAlertAction(title: "확인", style: .default, handler: nil)
                    saveAlert.addAction(saveOkAlert)
                    self.present(saveAlert, animated: false)
                }
                
                let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                addViewSatus = true
                self.present(alert, animated: false)
                
            }
            
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
    
    
    // 카메라 버튼 클릭
    @IBAction func cameraButtonClicked(_ sender: UIButton) {
        imageSatus = false
        // PHPicker 사용
        var configuartion = PHPickerConfiguration()
        // 선택할 수 있는 최대 asset 갯수, unlimited = 0
        configuartion.selectionLimit = 3
        configuartion.filter = .images
        
        let picker = PHPickerViewController(configuration: configuartion)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func closeButtonClicked(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
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
            
        
           
       
        }
    
    

    
    
    
    
}
