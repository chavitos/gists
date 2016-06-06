//
//  GistListViewController.swift
//  gists
//
//  Created by Tiago Chaves on 02/06/16.
//  Copyright © 2016 netshoes. All rights reserved.
//

import UIKit

class GistListViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var gistCollect: UICollectionView!
    
    var gistList:[Gist] = []
    var gist:Gist?
    
    //MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getGistList()
    }
    
    //MARK: - Local methods
    
    func getGistList(){
        
        GistMethods.downloadGistList(){ list, error in
            
            if error == nil{
                
                if let listaGist = list{
                    
                    self.gistList = listaGist
                    
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        
                        self.gistCollect.reloadData()
                    }
                }
            }else{
                
                print("Erro ao chamar o JSON de lista - " + (error?.description)!)
            }
        }
    }

    //MARK: - IBActions

    @IBAction func refreshGistList(sender: UIBarButtonItem) {
        
        self.getGistList()
        self.gistCollect.scrollToItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: true)
    }
    
    
    //MARK: - Collection methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.gistList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = gistCollect.dequeueReusableCellWithReuseIdentifier("gistCell", forIndexPath: indexPath) as! GistsCollectionViewCell
        
        cell.configCell(self.gistList[indexPath.row])
        
        return cell
    }

    //MARK: - Segue methods
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        self.gist = gistList[indexPath.row]
        self.callDetail()
    }
    
    func callDetail(){
        
        performSegueWithIdentifier("gistListToDetail", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let detailVC:GistDetailViewController = segue.destinationViewController as! GistDetailViewController
        
        detailVC.gist = self.gist
    }

}

