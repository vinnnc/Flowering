//
//  ChangePlantViewController.swift
//  Flowering
//
//  Created by Wenchu Du on 7/11/19.
//  Copyright © 2019 Personal. All rights reserved.
//

import UIKit
import CoreData

protocol ChangePlantDelegate {
    func changePlant(newPlant: Plant)
}

class ChangePlantViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var plantImageContainerView: UIView!
    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var plantNameTextField: UITextField!
    @IBOutlet weak var sunshineSegment: UISegmentedControl!
    @IBOutlet weak var temperatureSegment: UISegmentedControl!
    @IBOutlet weak var waterSegment: UISegmentedControl!
    @IBOutlet weak var fertilityPeriodTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var delegate: HomeViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Change plant image into circle with white border
        plantImage.layer.borderWidth = 5
        plantImage.layer.borderColor = UIColor.white.cgColor
        plantImage.layer.cornerRadius = plantImage.frame.size.width / 2
        
        // Add shadow to the image
        plantImageContainerView.layer.shadowColor = UIColor.black.cgColor
        plantImageContainerView.layer.shadowRadius = 10
        plantImageContainerView.layer.shadowOpacity = 0.8
        plantImageContainerView.layer.cornerRadius = plantImage.frame.size.width / 2
        plantImageContainerView.layer.masksToBounds = false
        
        // Component setup
        let plant = delegate?.plant
        
        if plant?.image == "home_flower" {
            plantImage.image = UIImage(named: "home_flower")
        } else {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let url = NSURL(fileURLWithPath: path)
            
            if let pathComponent = url.appendingPathComponent(plant!.image!) {
                let filePath = pathComponent.path
                let fileManager = FileManager.default
                let fileData = fileManager.contents(atPath: filePath)
                plantImage.image = UIImage(data: fileData!)
            }
        }
    
        if plant!.name != "Ready to Setup" {
            plantNameTextField.text = plant!.name
        }
        
        if Int(plant!.sunshine) != -1 {
            sunshineSegment.selectedSegmentIndex = Int(plant!.sunshine)
        } else {
            sunshineSegment.selectedSegmentIndex = 1
        }
        
        if Int(plant!.fertility) != -1 {
            fertilityPeriodTextField.text = String(plant!.fertility)
        }
        
        if Int(plant!.moisture) != -1 {
            waterSegment.selectedSegmentIndex = Int(plant!.moisture)
        } else {
            waterSegment.selectedSegmentIndex = 1
        }
        
        // Add tap anywhere to dismiss keyboard guesture
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        // Raise the view when the keyboard is appear
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func gestureTapPhoto(_ sender: Any) {
        let controller = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            controller.sourceType = .camera
        } else {
            controller.sourceType = .photoLibrary
        }
        
        controller.allowsEditing = false
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        // Generate image path
        let date = UInt(Date().timeIntervalSince1970)
        var data = Data()
        data = (plantImage.image?.jpegData(compressionQuality: 0.8)!)!
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        
        if let pathComponent = url.appendingPathComponent("\(date)") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            fileManager.createFile(atPath: filePath
                , contents: data, attributes: nil)
        }
        
        guard let name = plantNameTextField.text, name != "" else {
            displayMessage(title: "Save Failed", message: "Please enter the name of plant.")
            return
        }
        
        let sunshine = Int32(sunshineSegment.selectedSegmentIndex)
        let temperature = Int32(temperatureSegment.selectedSegmentIndex)
        let moisture = Int32(waterSegment.selectedSegmentIndex)
        
        guard let fertility = Int32(fertilityPeriodTextField.text!) else {
            displayMessage(title: "Save Failed", message: "Please enter a number to set fertility period day.")
            return
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let newPlant = NSEntityDescription.insertNewObject(forEntityName: "Plant", into: context) as! Plant
        
        newPlant.name = name
        newPlant.image = "\(date)"
        newPlant.sunshine = sunshine
        newPlant.fertility = fertility
        newPlant.temperature = temperature
        newPlant.moisture = moisture
        
        appDelegate.saveContext()
        delegate?.changePlant(newPlant: newPlant)
        dismiss(animated: true, completion: nil)        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            plantImage.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }

    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
