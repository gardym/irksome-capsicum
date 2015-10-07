//
//  MembersViewController.swift
//  ThoughtHub
//
//  Created by Mike Gardiner on 06/10/2015.
//  Copyright (c) 2015 Gardym. All rights reserved.
//

import UIKit

class MembersViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {

    let memberTableCellReuseIdentifier = "MemberCell"

    var membersJSON : AnyObject?
    var avatarPaths : [Int : String]?

    var memberJSON : [String : AnyObject]?

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

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        memberJSON = membersArray()[indexPath.row] as? [String : AnyObject]
        performSegueWithIdentifier("showMember", sender: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        (segue.destinationViewController as! MemberWebViewController).memberJSON = memberJSON
    }
}


