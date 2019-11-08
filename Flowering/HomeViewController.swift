//
//  HomeViewController.swift
//  Flowering
//
//  Created by Wenchu Du on 7/11/19.
//  Copyright © 2019 Personal. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
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
    
    var plant: Plant?
    
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
        
        loadData()
    }
    
    func loadData() {
        let defaultPlant = ["name": "Empty", "image": "home_flower", "sunshine": "-1", "temperature": "-1", "moisture": "-1", "fertility": "-1"]
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            try plant = context.fetch(Plant.fetchRequest()).first as Plant
        } catch {
            print("Failed to fetch data.")
        }
        
        if plant == nil {
            print("Adding default plant")
            
            let newPlant = NSEntityDescription.insertNewObject(forEntityName: "Plant", into: context) as! Plant
            newPlant.name = defaultPlant["name"]
            newPlant.image = defaultPlant["image"]
            newPlant.sunshine = Int32(defaultPlant["sunshine"])
            newPlant.temperature = Int32(defaultPlant["temperature"])
            newPlant.fertility = Int32(defaultPlant["fertility"])
            newPlant.moisture = Int32(defaultPlant["moisture"])
            
            appDelegate.saveContext()
        }
        
        do {
            try plant = (context.fetch(Record.fetchRequest()).first as? Plant)!
        } catch {
            print("Failed to adding default plant.")
        }
    }
}
