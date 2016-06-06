//
//  GistDetailViewController.swift
//  gists
//
//  Created by Tiago Chaves on 03/06/16.
//  Copyright © 2016 netshoes. All rights reserved.
//

import UIKit

class GistDetailViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imgUserAvatar: UIImageView!
    @IBOutlet weak var lblFork: UILabel!
    @IBOutlet weak var lblFile: UILabel!
    @IBOutlet weak var lblCommit: UILabel!
    
    @IBOutlet weak var lblFileName: UILabel!
    @IBOutlet weak var txtFileContent: UITextView!
    @IBOutlet weak var fileView: UIView!
    
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    
    var gist:Gist?

    //MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GistMethods.downloadGistDetail(self.gist!){ gist, error in
            
            if error == nil{
                
                if let detailGist = gist{
                    
                    self.gist = detailGist
                    
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        
                        self.txtFileContent.text = self.gist!.files!.first?.content
                        self.lblFileName.text = self.gist!.files!.first?.filename
                        self.lblFork.text = self.gist!.forks!.stringValue
                        
                        self.fileView.layer.borderWidth = 1.0
                        self.fileView.layer.cornerRadius = 4.0
                        self.fileView.layer.borderColor = UIColor(colorLiteralRed: 244/255, green: 242/255, blue: 240/255, alpha: 1.0).CGColor
                        
                        if(self.gist!.files!.count > 1){
                            
                            for index in 1...self.gist!.files!.count-1 {
                                
                                let y:CGFloat = 96.0 + (420.0 * CGFloat(index))
                                
                                let contentViewX = UIView(frame: CGRectMake(8.0, y, self.fileView.frame.size.width, self.fileView.frame.size.height))
                                contentViewX.backgroundColor = self.fileView.backgroundColor
                                contentViewX.layer.borderWidth = 1.0
                                contentViewX.layer.cornerRadius = 4.0
                                contentViewX.layer.borderColor = UIColor(colorLiteralRed: 244/255, green: 242/255, blue: 240/255, alpha: 1.0).CGColor
                                
                                let lblFileNameX = UILabel(frame: CGRectMake(8.0, 3.0, self.lblFileName.frame.size.width, self.lblFileName.frame.size.height))
                                lblFileNameX.text = self.gist!.files![index].filename
                                lblFileNameX.font = self.lblFileName.font
                                lblFileNameX.textColor = self.lblFileName.textColor
                                
                                let txtFileContentX = UITextView(frame: CGRectMake(0.0, 26.0, self.txtFileContent.frame.size.width, self.txtFileContent.frame.size.height))
                                txtFileContentX.text = self.gist!.files![index].content
                                txtFileContentX.font = self.txtFileContent.font
                                
                                contentViewX.addSubview(lblFileNameX)
                                contentViewX.addSubview(txtFileContentX)
                                
                                self.contentView.addSubview(contentViewX)
                            }
                            
                            self.scrollHeight.constant = CGFloat(self.gist!.files!.count) * 516.0
                        }
                    }
                }
            }else{
                
                print("Erro ao chamar o JSON de lista - " + (error?.description)!)
            }
            
        }

        self.configComponents()
    }

    
    // MARK: - Local methods
    
    func configComponents(){
        
        if(self.gist!.owner != nil){
            
            self.title = gist!.owner?.login
            self.downloadImage(NSURL(string: (gist!.owner?.avatarUrl)!)!)
        }else{
            
            self.title = "Anonymous"
            self.imgUserAvatar.image = UIImage(named: "anonymous")
            self.imgUserAvatar.contentMode = .Center
        }
        
        self.lblFile.text = (self.gist!.files!.count as NSNumber).stringValue
    }

    // MARK: - Download image
    
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
