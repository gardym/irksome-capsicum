//
//  AvatarLoader.swift
//  ThoughtHub
//
//  Created by Mike Gardiner on 06/10/2015.
//  Copyright (c) 2015 Gardym. All rights reserved.
//

import Foundation

protocol AvatarLoaderDelegate {
    func avatarsLoaded(avatarloader : AvatarLoader, finishedLoadingImagesToPaths: [Int : String])
}

class AvatarLoader {

    var membersJSON : [AnyObject]
    var delegate : AvatarLoaderDelegate?

    init(membersJSON: [AnyObject]) {
        self.membersJSON = membersJSON
    }

    func loadAvatars() {
        let urlSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        urlSessionConfiguration.HTTPMaximumConnectionsPerHost = 5

        let urlSession = NSURLSession(configuration: urlSessionConfiguration)

        var cachedURLs = [Int : String]()
        for memberJSON in membersJSON {
            if let member = memberJSON as? [String : AnyObject], memberID = member["id"] as? Int, avatarURL = member["avatar_url"] as? String {
                var task = urlSession.downloadTaskWithURL(NSURL(string: avatarURL)!, completionHandler: { (temporaryFileURL, response, err) -> Void in
                    var cachedURL = self.cacheTemporaryFile(memberID, temporaryFileURL: temporaryFileURL)
                    cachedURLs[memberID] = cachedURL

                    if(cachedURLs.count == self.membersJSON.count) {
                        // Go back to the main thread
                        dispatch_async(dispatch_get_main_queue()) {
                            self.delegate?.avatarsLoaded(self, finishedLoadingImagesToPaths: cachedURLs)
                        }
                    }

                    return
                })

                task.resume()
            }
        }
    }

    func cacheTemporaryFile(memberID : Int, temporaryFileURL: NSURL) -> String {
        var destinationPath = NSHomeDirectory().stringByAppendingPathComponent("Library/Caches/\(memberID).jpg")

        var err : NSError?
        NSFileManager.defaultManager().moveItemAtURL(temporaryFileURL, toURL: NSURL(string: "file://\(destinationPath)")!, error: &err)

        return destinationPath
    }
}
