//
//  MembersViewController.swift
//  ThoughtHub
//
//  Created by Mike Gardiner on 06/10/2015.
//  Copyright (c) 2015 Gardym. All rights reserved.
//

import UIKit

class MembersViewController: UITableViewController, UITableViewDataSource {

    let memberTableCellReuseIdentifier = "MemberCell"

    var membersJSON : AnyObject?
    var avatarPaths : [Int : String]?

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfMembers()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(memberTableCellReuseIdentifier) as! UITableViewCell

        if let member = membersArray()[indexPath.row] as? [String : AnyObject] {
            if let login = member["login"] as? String {
                cell.textLabel?.text = login
            }
            if let memberID = member["id"] as? Int, avatarPath = avatarPaths?[memberID] {
                cell.imageView?.image = UIImage(contentsOfFile: avatarPath)
            }
        }

        return cell
    }

    func membersArray() -> [AnyObject] {
        return membersJSON as! [AnyObject]
    }

    func numberOfMembers() -> Int {
        return (membersJSON as! [AnyObject]).count
    }

}