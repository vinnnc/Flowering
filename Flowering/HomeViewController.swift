//
//  HomeViewController.swift
//  Flowering
//
//  Created by Wenchu Du on 7/11/19.
//  Copyright © 2019 Personal. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import UserNotifications

class HomeViewController: UIViewController, ChangePlantDelegate {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var plantImageContainerView: UIView!
    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var plantNameLabel: UILabel!
    @IBOutlet weak var sunshineLabel: UILabel!
    @IBOutlet weak var sunshineDegreeImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var temperatureDegreeImage: UIImageView!
    @IBOutlet weak var moistureLabel: UILabel!
    @IBOutlet weak var moistureDegreeImage: UIImageView!
    @IBOutlet weak var fertilityLabel: UILabel!
    @IBOutlet weak var fertilityDegreeImage: UIImageView!
    
    var appDelegate: AppDelegate?
    var plant: Plant?
    var db: Firestore?
    var parameter: Parameter?
    var farmDate: FarmDate?
    var dates: [FarmDate] = []
    var day = 0
    var month = 0
    var year = 0
    
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
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        db = appDelegate?.db
        
        loadData()
        onParameterChange()
    }
    
    func loadData() {
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate!.persistentContainer.viewContext
        
        var plants = [Plant]()
        do {
            try plants = context.fetch(Plant.fetchRequest()) as [Plant]
        } catch {
            print("Failed to load plant data from database.")
        }
        
        if plants.count == 0 {
            plant = NSEntityDescription.insertNewObject(forEntityName: "Plant", into: context) as? Plant
            plant?.name = "Ready to Setup"
            plant?.image = "home_flower"
            plant?.sunshine = Int16(-1)
            plant?.temperature = Int16(-1)
            plant?.moisture = Int16(-1)
            plant?.fertility = Int16(-1)
            appDelegate!.saveContext()
        } else {
            plant = plants.last!
        }
        do {
            try dates = context.fetch(FarmDate.fetchRequest()) as [FarmDate]
        } catch {
            print("Failed to load plant data from database.")
        }
        
        
        
        if dates.count == 0 {
            farmDate = NSEntityDescription.insertNewObject(forEntityName: "FarmDate", into: context) as? FarmDate
            let today = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let new = dateFormatter.string(from: today)
            let currentDate = dateFormatter.date(from: new)
            let dformatter = DateFormatter()
            dformatter.dateFormat = "yyyy"
            farmDate?.year = Int16(dformatter.string(from: currentDate!)) ?? 0
            dformatter.dateFormat = "MM"
            farmDate?.month = Int16(dformatter.string(from: currentDate!)) ?? 0
            dformatter.dateFormat = "dd"
            farmDate?.day = Int16(dformatter.string(from: currentDate!)) ?? 0
            farmDate?.fert = false
            farmDate?.water = false
            appDelegate!.saveContext()
        }
        else{
            for farm in dates{
                if day == 0 && month == 0 && year == 0{
                    day = Int(farm.day)
                    month = Int(farm.month)
                    year = Int(farm.year)
                }
                else{
                    if farm.year > year{
                        year = Int(farm.year)
                        if farm.month > month {
                            month = Int(farm.month)
                            if farm.day > day{
                                day = Int(farm.day)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func onParameterChange() {
        db!.collection("parameter").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            
            self.parseParameterSnapshot(snapshot: documents.last!)
            self.updateView()
        }
    }
    
    func parseParameterSnapshot(snapshot: QueryDocumentSnapshot) {
        parameter = Parameter()
        let temp = snapshot.data()["temp"] as! NSNumber
        let illu = snapshot.data()["illu"] as! NSNumber
        let soil = snapshot.data()["soil"] as! NSNumber
        var str = String(format: "%.2f", temp.doubleValue)
        let newTemp = Double(str)
        str = String(format: "%.2f", illu.doubleValue)
        let newIllu = Double(str)
        str = String(soil.intValue)
        let newSoil = Int(str)
        parameter!.temp = newTemp
        parameter!.illu = newIllu
        parameter!.soil = newSoil
    }
    
    func updateView() {
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
        let illu = Double(parameter?.illu ?? 0)
        let temp = Double(parameter?.temp ?? 0)
        let soil = Int(parameter?.soil ?? 0)
        temperatureLabel.text = "\(temp) ˚C"
        sunshineLabel.text = "\(illu ) lux"
        moistureLabel.text = "\(soil)"
        plantNameLabel.text = plant?.name
        if illu < 1000 {
            sunshineDegreeImage.image = UIImage(named: "home_low")
            self.displayMessage(title: "Sunshine is too low", message: "Plase move plant to well-lighted area.")
            self.addNotification(title: "Sunshine is too low", body: "Plase move plant to well-lighted area.", identifier: "Sunshine")
        }
        else if illu >= 1000 && illu < 2000 {
            sunshineDegreeImage.image = UIImage(named: "home_middle")
        }
        else{
            sunshineDegreeImage.image = UIImage(named: "home_high")
            self.displayMessage(title: "Sunshine is too high", message: "Plase move plant to shadow.")
            self.addNotification(title: "Sunshine is too high", body: "Plase move plant to shadow.", identifier: "Sunshine")
        }
        
        if soil < 200 {
            moistureDegreeImage.image = UIImage(named: "home_low")
            self.displayMessage(title: "Soil moisture is too low", message: "Plase water your plant.")
            self.addNotification(title: "Soil moisture is too low", body: "Plase water your plant.", identifier: "Soil")
        }
        else if soil >= 200 && soil < 500 {
            moistureDegreeImage.image = UIImage(named: "home_middle")
        }
        else{
            moistureDegreeImage.image = UIImage(named: "home_high")
            self.displayMessage(title: "Soil moisture is too high", message: "Plase move plant to other area.")
            self.addNotification(title: "Soil moisture is too high", body: "Plase move plant to other area.", identifier: "Sunshine")
        }
        
        if temp < 18 {
            temperatureDegreeImage.image = UIImage(named: "home_low")
            self.displayMessage(title: "Temperature is too low", message: "Plase move plant to warm area.")
            self.addNotification(title: "Temperature is too low", body: "Plase move plant to warm area.", identifier: "Temperature")
        }
        else if temp >= 18 && temp < 25 {
            temperatureDegreeImage.image = UIImage(named: "home_middle")
        }
        else{
            temperatureDegreeImage.image = UIImage(named: "home_high")
            self.displayMessage(title: "Temperature is too high", message: "Plase move plant to shadow.")
            self.addNotification(title: "Temperature is too high", body: "Plase move plant to shadow.", identifier: "Temperature")
        }
        
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let newDate = dateFormatter.date(from: "\(year)-\(month)-\(day)")!
        let number = today.distance(to: newDate) / (3600 * 24 * 365)
        print(number)
        var farmDay = Double(plant?.fertility.distance(to: 0) ?? 1)
        if farmDay < 0{
            farmDay = 0 - farmDay + 0.00001
        }
        var num = number
        if num < 0{
            num = 0 - num
        }
        print(num)
        print(farmDay)
        let diff = Double((Double(num) + 0.001) / farmDay)
        print(diff)
        if diff <= 0.1{
            fertilityDegreeImage.image = UIImage(named: "home_high")
            fertilityLabel.text = "High"
        }
        else if diff > 0.1 && diff <= 0.67 {
            fertilityDegreeImage.image = UIImage(named: "home_middle")
            fertilityLabel.text = "Suffcient"
            
        }
        else{
            fertilityDegreeImage.image = UIImage(named: "home_low")
            fertilityLabel.text = "Low"
            self.displayMessage(title: "Fertility is too low", message: "Plase fertilitizing your plant.")
            self.addNotification(title: "Fertility is too low", body: "Plase fertilitizing your plant.", identifier: "Fertility")
        }
        print(today)
        dateFormatter.dateFormat = "HH:mm"
        let dayStart = dateFormatter.date(from: "08:00")
        let dayEnd = dateFormatter.date(from: "20:00")
        let current = dateFormatter.string(from: today)
        let currentTime = dateFormatter.date(from: current)
        if (currentTime?.compare(dayStart ?? currentTime!).rawValue) == 1 && (currentTime?.compare(dayEnd ?? currentTime!).rawValue) == -1 {
            backgroundImage.image = UIImage(named: "home_morning")
        }
        else{
            backgroundImage.image = UIImage(named: "home_night")
        }
    }
    
    func changePlant(newPlant: Plant) {
        plant = newPlant
        updateView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changePlantSegue" {
            let destination = segue.destination as! ChangePlantViewController
            destination.delegate = self
        }
    }
    
    func addNotification(title: String, body: String, identifier: String) {
        // Create a notification content object
        let notificationContent = UNMutableNotificationContent()
        
        // Create its details
        notificationContent.title = title
        notificationContent.body = body
        
        // Set a delayed trigger for the notification of 10 seconds
        let timeInterval = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        // Create our request
        // Provide a unique identifier, our content and the trigger
        let request = UNNotificationRequest(identifier: identifier , content: notificationContent, trigger: timeInterval)
        
        // Send the notification request to the Notification Centre
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
