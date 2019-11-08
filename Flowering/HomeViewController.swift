//
//  HomeViewController.swift
//  Flowering
//
//  Created by Wenchu Du on 7/11/19.
//  Copyright © 2019 Personal. All rights reserved.
//

import UIKit

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
        
    }
}
