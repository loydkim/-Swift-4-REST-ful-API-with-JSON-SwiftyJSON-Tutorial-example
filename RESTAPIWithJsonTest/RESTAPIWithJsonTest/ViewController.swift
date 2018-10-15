//
//  ViewController.swift
//  RESTAPIWithJsonTest
//
//  Created by YOUNGSIC KIM on 2018-10-14.
//  Copyright © 2018 YOUNGSIC KIM. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {
    var tableView:UITableView!
    var items = [UserObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // show the items in table.
        // when touch the button, get json data and save items. and then show it.
        let frame: CGRect = CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.height-100)
        self.tableView = UITableView(frame: frame)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.view.addSubview(self.tableView)
        
        // Get data using RestAPI.
        let btn = UIButton(frame: CGRect(x: 0, y: 25, width: self.view.frame.width, height: 50))
        btn.backgroundColor = UIColor.cyan
        btn.setTitle("Add new Dummy", for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(self.addDummyData), for: UIControl.Event.touchUpInside)
        self.view.addSubview(btn)
    }
    
    @objc func addDummyData() {
        // Call API
        RestApiManager.sharedInstance.getRandomUser { (json:JSON) in
            // return json from API
            if let results = json["results"].array { // get results data from json
                for entry in results { // save data to items.
                    self.items.append(UserObject(json: entry))
                }
                
                DispatchQueue.main.async { // back to the main que and reload table
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension ViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "CELL")
        }
        let user = self.items[indexPath.row]
        if let url = NSURL(string: user.pictureURL) {
            if let data = NSData(contentsOf: url as URL) {
                cell?.imageView?.image = UIImage(data: data as Data)
            }
        }
        cell!.textLabel?.text = user.username
        return cell!
    }
}
