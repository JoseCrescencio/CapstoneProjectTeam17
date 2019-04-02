//
//  NewPlanViewController.swift
//  MeasureARPusher
//
//  Created by Angel on 3/6/19.
//  Copyright © 2019 Celina. All rights reserved.
//

import UIKit
import Parse

class NewPlanViewController: UIViewController {
    
    //Textfields
    @IBOutlet weak var floorPlanName: UITextField!
    @IBOutlet weak var customerName: UITextField!
    @IBOutlet weak var customerID: UITextField!
    @IBOutlet weak var additionalInfo: UITextView!
    
    //Labels
    @IBOutlet weak var levelCount: UILabel!
    @IBOutlet weak var roomCount: UILabel!
    
    //Buttons
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var floorPlanButton: UIButton!
    
    
    //@IBOutlet weak var displayView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.layer.cornerRadius = 4
        floorPlanButton.layer.cornerRadius = 4
        
        floorPlanName.delegate = self as? UITextFieldDelegate
        customerName.delegate = self as? UITextFieldDelegate
        customerID.delegate = self as? UITextFieldDelegate
        additionalInfo.delegate = self as? UITextFieldDelegate as? UITextViewDelegate
        // Do any additional setup after loading the view.
    }
    //Getting level count
    @IBAction func levelStepper(_ sender: UIStepper) {
        var number = 0
        number = Int(sender.value)
        levelCount.text = String(number)
    }
    //Getting room count
    @IBAction func roomStepper(_ sender: UIStepper) {
        var number = 0
        number = Int(sender.value)
        roomCount.text = String(number)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        //Creating Object
        let floorPlan = PFObject(className:"FloorPlan")
        floorPlan["floorPlanName"] = floorPlanName.text
        floorPlan["customerName"] = customerName.text
        floorPlan["customerID"] = customerID.text
        floorPlan["levelCount"] = levelCount.text!
        floorPlan["roomCount"] = roomCount.text!
        floorPlan["additionalInfo"] = additionalInfo.text
        floorPlan.saveInBackground {
            (success: Bool, error: Error?) in
            if (success) {
                // The object has been saved.
                //Maybe create pop-up for success
            } else {
                // There was a problem, check error.description
                //Maybe create pop-up for failure
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        floorPlanName.resignFirstResponder()
        customerName.resignFirstResponder()
        customerID.resignFirstResponder()
        additionalInfo.resignFirstResponder()
    }
    
}

extension ViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
