//
//  PlanEditorViewController.swift
//  MeasureARPusher
//
//  Created by Angel on 3/6/19.
//  Copyright © 2019 Celina. All rights reserved.
//

import UIKit
//import CollectionKit


class PlanEditorViewController: UIViewController{
   

    
    @IBOutlet weak var addButton: UIButton! //button that is NOT in the collection View
    @IBOutlet weak var roomImage: UIImageView! //Img that is NOT in the collection view
    
   
    

    
    //Function NOT in the collection view to change button into img //
    @IBAction func pressedButton(_ sender: Any) {
        addButton.isEnabled = false
        if (!addButton.isEnabled){
            print("DISABLED")
            addButton.isHidden = true
        }
        addButton.setTitle("my text here", for: .disabled)
        roomImage.image = UIImage(named: "floorplan")
        print("yourButton was pressed")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    


        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
 

