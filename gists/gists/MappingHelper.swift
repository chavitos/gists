//
//  MappingHelper.swift
//  gists
//
//  Created by Tiago Chaves Mobile on 02/06/16.
//  Copyright © 2016 netshoes. All rights reserved.
//

import UIKit

class MappingHelper: NSObject {

    class func parseGistData(gist:NSDictionary) -> Gist{
        
        let nGist:Gist = Gist()
        
        nGist.comments = gist["comments"] as? NSNumber
        nGist.id = gist["id"] as? String
        nGist.isPublic = gist["public"] as? NSNumber
        nGist.updatedAt = gist["updated_at"] as? NSDate
        nGist.createdAt = gist["created_at"] as? NSDate
        nGist.desc = gist["description"] as? String

        nGist.files = self.parseFileData(gist["files"]!)
        
        if((gist["owner"]) != nil){
            
            let dictOwner:NSDictionary = (gist["owner"] as? NSDictionary)!
            let owner:Owner = Owner()
            
            owner.login = dictOwner["login"] as? String
            owner.id = dictOwner["id"] as? String
            owner.avatarUrl = dictOwner["avatar_url"] as? String
            owner.url = dictOwner["url"] as? String
            
            nGist.owner = owner
        }
        
        return nGist
    }
    
    class func parseFileData(file:AnyObject) -> [File]{
        
        let keys:[String] = file.allKeys as! [String]
        
        var filesList:[File] = []
        
        for key in keys {
         
            let nFile:File = File()
            
            nFile.filename = file[key]!!["filename"] as? String
            nFile.type = file[key]!!["type"] as? String
            nFile.language = file[key]!!["language"] as? String
            nFile.rawUrl = file[key]!!["raw_url"] as? String
            
            if (file["content"] != nil) {
                
                nFile.content = file["content"] as? String
            }
            
            filesList.append(nFile)
        }
        
        return filesList
    }
}
