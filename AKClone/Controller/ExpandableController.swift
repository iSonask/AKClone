//
//  ExpandableController.swift
//  AKClone
//
//  Created by Akash on 16/11/17.
//  Copyright © 2017 Akash. All rights reserved.
//

import UIKit

class ExpandableController: UITableViewController, StoryboardRedirectionProtocol {

    var topItems = [String]()
    var subItems = [String]()
    var selectedIndexPathSection:Int = -1
    var expandedItemList = [Int]()
    
    @IBOutlet var expandablesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topItems = ["26th April 2017","27th April 2017","28th April 2017","29th April 2017","30th April 2017"]
        subItems = ["Monday","TuesDay","WednessDay"]
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Expandable"
        // Do any additional setup after loading the view, typically from a nib.
    }
    @objc func headerCellButtonTapped(_ sender: UIButton)
    {
        for i in 0 ..< expandedItemList.count  {
            
            if(expandedItemList[i] == (sender.tag-100))
            {
                expandedItemList.remove(at: i)
                self.expandablesTableView.reloadData()
                
                return
            }
        }
        selectedIndexPathSection = sender.tag - 100
        expandedItemList.append(selectedIndexPathSection)
        
        UIView.animate(withDuration: 0.3, delay: 1.0, options: UIViewAnimationOptions.transitionCrossDissolve , animations: {
            self.expandablesTableView.reloadData()
        }, completion: nil)
        
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int{
        return topItems.count
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "TopCell") as! TopCell
        headerCell.textLabel?.text = topItems[section]as String
        headerCell.backgroundColor = UIColor.lightGray
        //a buttton is added on the top of all UI elements on the cell and its tag is being set as header's section.
        
        headerCell.btnTap.tag =  section+100
        headerCell.btnTap.addTarget(self, action: #selector(headerCellButtonTapped), for: UIControlEvents.touchUpInside)
        
        //minimize and maximize image with animation.
        if(expandedItemList.contains(section))
        {
            UIView.animate(withDuration: 0.3, delay: 1.0, usingSpringWithDamping: 5.0, initialSpringVelocity: 5.0, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
            }, completion: nil)
        }
        else{
            
            UIView.animate(withDuration: 0.3, delay: 1.0, usingSpringWithDamping: 5.0, initialSpringVelocity: 5.0, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
            }, completion: nil)
        }
        
        return headerCell
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        for var i in 0 ..< expandedItemList.count  {
            
            if(expandedItemList[i] == section)
            {
                i = expandedItemList.count
                return 0
            }
        }
        return self.subItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubItemCell") as! SubItemCell
        cell.textLabel?.text = subItems[indexPath.row]
        return cell
    }
}

class TopCell: UITableViewCell {
    
    @IBOutlet var btnTap: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
class SubItemCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
