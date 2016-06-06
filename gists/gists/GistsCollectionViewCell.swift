//
//  GistsCollectionViewCell.swift
//  gists
//
//  Created by Tiago Chaves on 02/06/16.
//  Copyright © 2016 netshoes. All rights reserved.
//

import UIKit

class GistsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgUserAvatar: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblFileType: UILabel!
    @IBOutlet weak var lblFileLanguage: UILabel!
    
    //MARK: - Override methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgUserAvatar.image = nil;
    }
    
    //MARK: - Local methods
    
    func configCell(gist:Gist){
        
        if(gist.owner != nil){
            
            self.lblUserName.text = gist.owner?.login
            
            self.downloadImage(NSURL(string: (gist.owner?.avatarUrl)!)!)
        }else{
            
            self.lblUserName.text = "Anonymous"
            self.imgUserAvatar.image = UIImage(named: "anonymous")
            self.imgUserAvatar.contentMode = .Center
        }
        
        self.lblFileType.text = gist.files!.first?.type
        self.lblFileLanguage.text = gist.files!.first?.language != nil ? gist.files!.first?.language : "-"
    }
    
    //Load images methods
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    func downloadImage(url: NSURL){
        
        getDataFromUrl(url) { (data, response, error)  in
            
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                
                guard let data = data where error == nil else { return }
                
                self.imgUserAvatar.image = UIImage(data: data)
                self.imgUserAvatar.contentMode = .ScaleAspectFit
            }
        }
    }
}
