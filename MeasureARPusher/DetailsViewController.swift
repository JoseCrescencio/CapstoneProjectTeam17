//
//  DetailsViewController.swift
//  MeasureARPusher
//
//  Created by Angel on 3/6/19.
//  Copyright © 2019 Celina. All rights reserved.
//

import UIKit
import Parse

class DetailsViewController: UIViewController {
    var details = [PFObject]();//Will pass information to this variable
    @IBOutlet weak var planNameLabel: UILabel!
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var customerIDLabel: UILabel!
    @IBOutlet weak var levelCountLabel: UILabel!
    @IBOutlet weak var roomCountLabel: UILabel!
    //@IBOutlet weak var addInfoView: UITextView!
    @IBOutlet weak var infoView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let plan = self.details[0]
        planNameLabel.text = plan["floorPlanName"] as? String
        customerNameLabel.text = plan["customerName"] as? String
        customerIDLabel.text = plan["customerID"] as? String
        levelCountLabel.text = plan["levelCount"] as? String
        roomCountLabel.text = plan["roomCount"] as? String
        infoView.text = plan["additionalInfo"] as? String

        // Do any additional setup after loading the view.
    }
    
    
    
}
