//
//  TipsViewController.swift
//  Flowering
//
//  Created by Wenchu Du on 9/11/19.
//  Copyright © 2019 Personal. All rights reserved.
//

import UIKit
import WebKit

class TipsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func gestureTapView1(_ sender: Any) {
        performSegue(withIdentifier: "webSegue", sender: "https://www.abc.net.au/life/12-easy-indoor-plants-for-beginners/10967302")
    }
    
    @IBAction func gestureTapView2(_ sender: Any) {
        performSegue(withIdentifier: "webSegue", sender: "https://www.rd.com/home/gardening/healthy-houseplant-tips/")
    }
    
    @IBAction func gestureTapView3(_ sender: Any) {
        performSegue(withIdentifier: "webSegue", sender: "https://www.naturespath.com/en-us/blog/7-indoor-gardening-tips-for-thriving-houseplants/")
    }
    
    @IBAction func gestureTapView4(_ sender: Any) {
        performSegue(withIdentifier: "webSegue", sender: "https://www.thesill.com/blogs/the-basics/top-ten-plant-care-tips")
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "webSegue" {
            let destination = segue.destination as! WebViewController
            destination.urlStr = sender as? String
        }
    }

}
