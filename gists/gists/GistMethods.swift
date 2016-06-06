//
//  GistMethods.swift
//  gists
//
//  Created by Tiago Chaves on 02/06/16.
//  Copyright © 2016 netshoes. All rights reserved.
//

import UIKit

class GistMethods: NSObject {
    
    class func downloadGistList(completionHandler:([Gist]?,NSError?) -> Void) {
        
        let requestURL: NSURL = NSURL(string: ConstantHelper.gistDownloadUrl)!
        
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            if error == nil {
                
                let httpResponse = response as! NSHTTPURLResponse
                let statusCode = httpResponse.statusCode
                
                if (statusCode == 200) {
                    
                    print("Método retornado com sucesso")
                    
                    var list:[Gist] = []
                    
                    do{
                        
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                        
                        if let gists = json as? [[String: AnyObject]] {
                            
                            for gist in gists {
                                
                                list.append(MappingHelper.parseGistData(gist))
                            }
                        }
                        
                        completionHandler(list,nil)
                        
                    }catch {
                        print("Erro ao tentar recuperar o JSON: \(error)")
                        
                    }
                }else{
                    
                    completionHandler(nil,error)
                }
            }else{
                
                completionHandler(nil,error)
            }
        }
        
        task.resume()
    }
    
    class func downloadGistDetail(gist:Gist,completionHandler:(Gist?,NSError?) -> Void){
        
        let requestURL: NSURL = NSURL(string: ConstantHelper.gistUrl + ConstantHelper.gists + gist.id!)!
        
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            if error == nil {
                
                let httpResponse = response as! NSHTTPURLResponse
                let statusCode = httpResponse.statusCode
                
                if (statusCode == 200) {
                    
                    print("Método retornado com sucesso")
                    
                    do{
                        
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                        
                        let file = json["files"]!! as AnyObject
                        let keys:[String] = file.allKeys as! [String]
                        var filesList:[File] = []
                        
                        for key in keys {
                            
                            let nFile:File = File()
                            
                            nFile.filename = file[key]!!["filename"] as? String
                            nFile.type = file[key]!!["type"] as? String
                            nFile.language = file[key]!!["language"] as? String
                            nFile.rawUrl = file[key]!!["raw_url"] as? String
                            nFile.content = file[key]!!["content"] as? String
                            
                            filesList.append(nFile)
                        }
                        
                        gist.files! = filesList
                        
                        gist.forks = json["forks"] != nil ? (json["forks"] as! NSArray).count as NSNumber : 0
                        
                        completionHandler(gist,nil)
                        
                    }catch {
                        print("Erro ao tentar recuperar o JSON: \(error)")
                        
                    }
                }else{
                    
                    completionHandler(nil,error)
                }
            }else{
                
                completionHandler(nil,error)
            }
        }
        
        task.resume()
    }
}
