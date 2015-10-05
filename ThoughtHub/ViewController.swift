//
//  ViewController.swift
//  ThoughtHub
//
//  Created by Mike Gardiner on 05/10/2015.
//  Copyright (c) 2015 Gardym. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let orgMembersURL = "https://api.github.com/orgs/thoughtworks/members"
    let memberURL = "https://api.github.com/users/"

    @IBOutlet weak var errorLabel : UILabel?
    @IBOutlet weak var activityIndicator : UIActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        var membersURL = NSURL(string: orgMembersURL)!
        var membersTask = NSURLSession.sharedSession().dataTaskWithURL(membersURL, completionHandler: { (data, response, err) -> Void in
            var jsonError : NSError?

            var membersJSON : AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &jsonError)!

            if(jsonError != nil) {
                // Error parsing JSON, let's ignore this for now...
            } else {
                println(membersJSON)

                if(err != nil || (response as! NSHTTPURLResponse).statusCode != 200) {
                    self.activityIndicator?.hidden = true

                    self.errorLabel?.hidden = false
                    self.errorLabel?.text = membersJSON["message"] as? String
                } else {
                    // What's should we do here? Read on and we'll find out...
                }
            }
        })

        membersTask.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

