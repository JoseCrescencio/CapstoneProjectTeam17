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
    
    //Saved variable
    var saved = true
    
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
        if emptyFields() && self.saved{
            floorPlan.saveInBackground {
                (success: Bool, error: Error?) in
                if (success) {
                    //Alert to notify a save was done
                    self.myAlert(name: "Save Succesful",note: "Your information has been saved.")
                    self.saved = false
        
                } else {
                    //Alert to notify a save was NOT done
                    self.myAlert(name: "Save Error",note: "Your information has not been saved!")
                }
            }
        }
        else if saved == false{
            //Alert to notify that a save has already been made.
            self.myAlert(name: "Saved",note: "Your information has already been saved.")
        }
    }
   //Function to alert user of empty textfields
   func emptyFields() -> Bool{
    
        if floorPlanName.text?.isEmpty ?? true {
            self.myAlert(name: "Missing information",note: "Your information was not saved.")
            return false
        }
        else if customerName.text?.isEmpty ?? true {
            self.myAlert(name: "Missing information",note: "Your information was not saved.")
            return false
        }
        else if customerID.text?.isEmpty ?? true {
            self.myAlert(name: "Missing information",note: "Your information was not saved.")
            return false
        }
        else if additionalInfo.text?.isEmpty ?? true {
            self.myAlert(name: "Missing information",note: "Your information was not saved.")
            return false
        }
        return true

    }
    
    //Alert function to notify user
    func myAlert(name: String, note: String){
        let alert  = UIAlertController(title: name, message: note, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)

    }
    
    //Lets a user touch around the keyboard to remove it
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
