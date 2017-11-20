//
//  CoreDataController.swift
//  AKClone
//
//  Created by Akash on 17/11/17.
//  Copyright © 2017 Akash. All rights reserved.
//

import UIKit
import CoreData

class CoreDataController: BaseController {

    @IBOutlet weak var coreDataTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
extension CoreDataController: UITableViewDelegate{
    
}
extension CoreDataController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
}
