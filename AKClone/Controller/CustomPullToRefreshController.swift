//
//  CustomPullToRefreshController.swift
//  AKClone
//
//  Created by Akash on 16/11/17.
//  Copyright © 2017 Akash. All rights reserved.
//

import UIKit

class CustomPullToRefreshController: UITableViewController,StoryboardRedirectionProtocol {

    var refreshc: UIRefreshControl!
    var customRefreshView: UIView!
    var isChecked = [Bool]()
    
    override func viewDidLoad() {
        
        navigationController?.navigationBar.prefersLargeTitles = false

        refreshc = createRefreshControl()
        loadCustomRefreshContents()
        self.tableView.addSubview(refreshc)
        for i in 0...100{
            if i % 2 == 0{
                isChecked.append(true)
            } else{
                isChecked.append(false)
            }
        }
        tableView.reloadData()
        
    }
    
    func createRefreshControl() -> UIRefreshControl{
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = .clear
        refreshControl.tintColor = .clear
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }
    
    func loadCustomRefreshContents() {
        let refreshContents = Bundle.main.loadNibNamed("CustomPullToRefresh", owner: self, options: nil)
        customRefreshView = refreshContents![0] as! UIView
        customRefreshView.frame = refreshc.bounds
        refreshc.addSubview(customRefreshView)
    }
    
    @objc func refresh(refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isChecked.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(indexPath.row + 1) \(isChecked[indexPath.row])"
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }
    
}
