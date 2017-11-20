//
//  ViewController.swift
//  AKClone
//
//  Created by Akash on 16/11/17.
//  Copyright © 2017 Akash. All rights reserved.
//

import UIKit

class ViewController: BaseController {

    @IBOutlet weak var selectionTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Select Any"
        
        setupInputs()
        //单击监听
    }
    func setupInputs()  {
        selectionTableView.backgroundColor = .clear
        selectionTableView.separatorStyle = .none
    }
}
extension ViewController: UITableViewDelegate{
    
}
extension ViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectionCell", for: indexPath) as! SelectionCell
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "Calculator"
        case 1:
            cell.titleLabel.text = "Custom Pull to Refresh"
        case 2:
            cell.titleLabel.text = "Draw"
        case 3:
            cell.titleLabel.text = "Expandable Cell "
        case 4:
            cell.titleLabel.text = "Instagram Gradient View"
        case 5:
            cell.titleLabel.text = "Keyed Archiver Demo"
        case 6:
            cell.titleLabel.text = "Network Rechability"
        case 7:
            cell.titleLabel.text = "Core Data"
        case 8:
            cell.titleLabel.text = "Notification Demo"
        default:
            cell.titleLabel.text = "Index \(indexPath.row)"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            print("Calculator")
            self.tapSingleDid()
            let calculator = CalculatorController.getViewController()
            navigationController?.pushViewController(calculator, animated: true)
        case 1:
            print("Pull to Refresh")
            self.tapSingleDid()
            let customPulltoRefresh = CustomPullToRefreshController.getViewController()
            navigationController?.pushViewController(customPulltoRefresh, animated: true)
        case 2:
            print("Draw")
            self.tapSingleDid()
            let draw = DrawController.getViewController()
            navigationController?.pushViewController(draw, animated: true)
        case 3:
            print("Expandable Cell----Incomplete")
            self.tapSingleDid()
//            let expandable = ExpandableController.getViewController()
//            navigationController?.pushViewController(expandable, animated: true)
        case 4:
            print("Insta gradient")
            self.tapSingleDid()
            let insta = InstaGradientController.getViewController()
            navigationController?.pushViewController(insta, animated: true)
        case 5:
            print("Keyed archiver")
            self.tapSingleDid()
            let archiver = KeydArchiveController.getViewController()
            navigationController?.pushViewController(archiver, animated: true)
        case 6:
            print("Rechable")
            self.tapSingleDid()
            let rechability = RechabilityController.getViewController()
            navigationController?.pushViewController(rechability, animated: true)
        case 7:
            print("Core data")
            self.tapSingleDid()
            let coredata = CoreDataController.getViewController()
            navigationController?.pushViewController(coredata, animated: true)
        case 8:
            print("Notification")
            self.tapSingleDid()
            let notification = NotificationController.getViewController()
            navigationController?.pushViewController(notification, animated: true)
        default:
            print("hey")
        }
    }
}

