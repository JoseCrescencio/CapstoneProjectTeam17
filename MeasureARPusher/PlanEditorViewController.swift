//
//  PlanEditorViewController.swift
//  MeasureARPusher
//
//  Created by Angel on 3/6/19.
//  Copyright © 2019 Celina. All rights reserved.
//

import UIKit
import CollectionKit


class PlanEditorViewController: UIViewController{

    
    @IBOutlet weak var addR: UIButton!

    @IBOutlet weak var roomIm: UIImageView!
    @IBAction func addRoom(_ sender: Any) {
        addR.isEnabled = false
        if (!addR.isEnabled){
            print("DISABLED")
            addR.isHidden = true
        }
        addR.setTitle("my text here", for: .disabled)
        roomIm.image = UIImage(named: "floorplan")
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
    
 

