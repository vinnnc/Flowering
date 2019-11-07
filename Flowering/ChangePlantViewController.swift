//
//  ChangePlantViewController.swift
//  Flowering
//
//  Created by Wenchu Du on 7/11/19.
//  Copyright © 2019 Personal. All rights reserved.
//

import UIKit

class ChangePlantViewController: UIViewController {
    @IBOutlet weak var plantImageContainerView: UIView!
    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var plantNameTextField: UITextField!
    @IBOutlet weak var sunshineSegment: UISegmentedControl!
    @IBOutlet weak var temperatureSegment: UISegmentedControl!
    @IBOutlet weak var waterSegment: UISegmentedControl!
    @IBOutlet weak var fertilityPeriodTextField: UITextField!
    
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
    
    @IBAction func save(_ sender: Any) {
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
