//
//  HomeViewController.swift
//  MeasureARPusher
//
//  Created by Angel on 3/6/19.
//  Copyright © 2019 Celina. All rights reserved.
//
import UIKit
import Parse

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //    @IBOutlet weak var FloorPlanTableView: UITableView!
    @IBOutlet weak var FloorPlanTableView: UITableView!
    var plans = [PFObject]();
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        FloorPlanTableView.delegate = self
        FloorPlanTableView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Getting array of objects
        let query = PFQuery(className:"FloorPlan")
        print(query)
        query.includeKey("floorPlanName")
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if let error = error {
                // Log details of the failure
                print(error.localizedDescription)
            } else{
                self.plans = objects!
                self.FloorPlanTableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        //Sending out selected cell information.
        if let destination = segue.destination as? DetailsViewController{
            destination.details = [plans[(FloorPlanTableView.indexPathForSelectedRow?.row)!]]
            FloorPlanTableView.deselectRow(at: FloorPlanTableView.indexPathForSelectedRow!, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FloorPlanCell") as! FloorPlanCell
        //Displaying floor plan names
        let plan = self.plans[indexPath.row]
        cell.FloorPlanLabel.text = plan["floorPlanName"] as? String
        
        return cell
    }
    
}
