//
//  HomeViewController.swift
//  MeasureARPusher
//
//  Created by Angel on 3/6/19.
//  Copyright © 2019 Celina. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var FloorPlanTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        FloorPlanTableView.delegate = self
        FloorPlanTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FloorPlanCell") as! FloorPlanCell
        
        cell.FloorPlanLabel.text = "BIT Building"
        
        return cell
    }

}
