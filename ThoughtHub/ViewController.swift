//
//  ViewController.swift
//  ThoughtHub
//
//  Created by Mike Gardiner on 05/10/2015.
//  Copyright (c) 2015 Gardym. All rights reserved.
//

import UIKit

class ViewController: UIViewController, AvatarLoaderDelegate {

    let orgMembersURL = "https://api.github.com/orgs/thoughtworks/members"
    let memberURL = "https://api.github.com/users/"

    @IBOutlet weak var errorLabel : UILabel?
    @IBOutlet weak var activityIndicator : UIActivityIndicatorView?

    var membersJSON : AnyObject?
    var avatarPaths : [Int : String]?

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
                    self.membersJSON = membersJSON

                    var avatarLoader = AvatarLoader(membersJSON: self.membersJSON as! [AnyObject])
                    avatarLoader.delegate = self
                    avatarLoader.loadAvatars()
                }
            }
        })

        membersTask.resume()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destinationVC = segue.destinationViewController as! MembersViewController
        destinationVC.membersJSON = self.membersJSON
        destinationVC.avatarPaths = self.avatarPaths
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func avatarsLoaded(avatarloader : AvatarLoader, finishedLoadingImagesToPaths: [Int : String]) {
        self.avatarPaths = finishedLoadingImagesToPaths
        self.performSegueWithIdentifier("showMembers", sender: nil)
    }
}

