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
    
    var appDelegate: AppDelegate?
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
            plant?.sunshine = Int32(-1)
            plant?.temperature = Int32(-1)
            plant?.moisture = Int32(-1)
            plant?.fertility = Int32(-1)
            appDelegate!.saveContext()
        } else {
            plant = plants.first!
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changePlantSegue" {
            let destination = segue.destination as! ChangePlantViewController
            destination.plant = plant
        }
    }
}
