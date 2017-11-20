//
//  KeydArchiveController.swift
//  AKClone
//
//  Created by Akash on 16/11/17.
//  Copyright © 2017 Akash. All rights reserved.
//

import UIKit

class KeydArchiveController: BaseController {

    
    @IBOutlet weak var archivedTableView: UITableView!
    var filePath : String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
        return url.appendingPathComponent("objectsArray")!.path
    }
    var peoples = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Keyed Archiver"
        setupControlls()
    }
    func setupControlls()  {
        archivedTableView.backgroundColor = .clear
        archivedTableView.separatorStyle = .none
        
        let createButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleCreateAction))
        navigationItem.rightBarButtonItem = createButton
    }
    
    @objc func handleCreateAction() {
        let alert = UIAlertController(title: "", message: "Enter Text", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Name"
            
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Age"
            textField.keyboardType = .numberPad
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
            guard let studentName = alert?.textFields![0].text!,
                let studentAge = alert?.textFields![1].text!  else {return}
            print(studentName)
            print(studentAge)
            let studentDetail = Person(name: studentName, age: Int(studentAge)!)
            var people = [Person]()
            people += [studentDetail]
            NSKeyedArchiver.archiveRootObject(people, toFile: self.filePath)
            self.getArchivedData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: {_ in
            print("cancel")
        }))
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
    }
    func getArchivedData()  {
        guard let people = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [Person]  else {
            return
        }
        self.peoples = people
        print(peoples[0].name)
        archivedTableView.reloadData()

//        if let array = {
//            array.forEach({print($0.name,$0.age)})
//        }
    }
}
extension KeydArchiveController: UITableViewDelegate{
    
}
extension KeydArchiveController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peoples.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArchiverCell", for: indexPath) as! ArchiverCell
        let people = peoples[indexPath.row]
        cell.titleLabel?.text = "\(people.name)  --  \(people.age)"
//        cell.detailTextLabel?.text =
        return cell
    }
}
