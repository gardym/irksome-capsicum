//
//  MemberWebViewController.swift
//  ThoughtHub
//
//  Created by Mike Gardiner on 07/10/2015.
//  Copyright (c) 2015 Gardym. All rights reserved.
//

import UIKit
import WebKit

class MemberWebViewController : UIViewController {

    let memberWebView : WKWebView = WKWebView()

    var memberJSON : [String : AnyObject]?

    override func loadView() {
        super.loadView()
        memberWebView.frame = view.frame
        view.addSubview(memberWebView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let memberJSON = memberJSON {
            if let memberURL = memberJSON["html_url"] as? String {
                memberWebView.loadRequest(NSURLRequest(URL: NSURL(string: memberURL)!))
            }
            if let login = memberJSON["login"] as? String {
                title = login
            }
        }
    }

}
