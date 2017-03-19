//
//  ViewController.swift
//  ProofKogi
//
//  Controller of the view that search to an specific artist
//
//  Created by Patricia Zambrano on 3/15/17.
//  Copyright © 2017 Patricia Zambrano. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import AlamofireImage

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var artistField: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    
    var listInfo = [JSON]()
    var listImage = [JSON]()
    var urlArray = [String]()
    var images = [UIImage]()
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let langID = Locale.preferredLanguages[0]
        let lang = (Locale.current as NSLocale).displayName(forKey: NSLocale.Key.languageCode, value: langID)
        
        initText()
        
        // Do any additional setup after loading the view, typically from a nib.
        let singleFingerTap = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleSingleTap(_:)))
        self.view.addGestureRecognizer(singleFingerTap)
        
        searchBtn.addTarget(self, action: #selector(ViewController.searchAction(_:)), for: .touchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     *  description: Action to display when is pressed the search button
     */
    @IBAction func searchAction(_ sender: UIButton) {
        
        self.view.endEditing(true)

        SVProgressHUD.show(withStatus: NSLocalizedString("Searching", comment: ""))
        
        if artistField.text! == ""{
            SVProgressHUD.showError(withStatus: NSLocalizedString("Field empty. Try again", comment: ""))
        }
        else {
            if artistField.text!.capitalized != SomeManager.sharedInstance.nameArtist.capitalized {
                
                self.initStructs()

                let param = [
                    "q": artistField.text!,
                    "type": "artist",
                    ] as [String : Any]
                
                Alamofire.request(Router.search(param as [String : AnyObject]))
                    .validate()
                    .responseJSON { response in
                        
                        if response.result.isSuccess{
                            
                            let info = (JSON(response.result.value!))["artists"]["items"].arrayValue
                            
                            self.listInfo = info
                            
                            SomeManager.sharedInstance.nameArtist = self.listInfo[0]["name"].stringValue
                            self.listImage = self.listInfo[0]["images"].arrayValue
                            
                            var j = 0
                            for i in 0..<self.listImage.count{
                                self.urlArray.insert(self.listImage[i]["url"].debugDescription, at: j)
                                j += 1
                            }

                            SomeManager.sharedInstance.listURLImages = self.urlArray
                            
                            SomeManager.sharedInstance.popularity = self.listInfo[0]["popularity"].int!
                            SomeManager.sharedInstance.followers = self.listInfo[0]["followers"]["total"].int!
                            SomeManager.sharedInstance.idArtist = self.listInfo[0]["id"].stringValue
                            
                            j = 0
                            for i in 0..<SomeManager.sharedInstance.listURLImages.count{
                                Alamofire.request(SomeManager.sharedInstance.listURLImages[i], method: .get)
                                    .responseImage { response in
                                        if response.result.isSuccess{
                                            
                                            self.images.insert((response.result.value?.af_imageAspectScaled(toFill: CGSize(width: 90.0, height: 90.0)))!, at: j)
                                            j += 1
                                            if i == SomeManager.sharedInstance.listURLImages.count - 1{
                                                SomeManager.sharedInstance.listImages = self.images

                                            }
                                        }
                                }
                            }
                            
                            SVProgressHUD.showSuccess(withStatus: NSLocalizedString("Successfull search", comment: ""))
                            
                        } else {
                            print(response.debugDescription)
                            SVProgressHUD.showError(withStatus: NSLocalizedString("Error while trying to search the artist", comment: ""))
                        }
                }
            }
            else {
                SVProgressHUD.showSuccess(withStatus: NSLocalizedString("Successfull search", comment: ""))
            }
        }
        
    }
    
    @IBAction func SearchGoBtn(_ sender: Any) {
        if !(artistField.text! == ""){
            let myVC = storyboard?.instantiateViewController(withIdentifier: "ArtistView") as! ArtistView
            myVC.nameArtist = SomeManager.sharedInstance.nameArtist
            navigationController?.pushViewController(myVC, animated: true)
        }
        
    }
    
    //****************
    //
    //  TextField delegate
    //
    //***************
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == artistField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
            self.view.endEditing(true)
    }
    
    func handleSingleTap(_ recognizer: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
        
    /*
     *  description: Initialize texts of the view
     */
    func initText() {
        artistField.placeholder = NSLocalizedString("Artist", comment: "")
        searchBtn.setTitle(NSLocalizedString("Search", comment: ""), for: UIControlState())
    }
    
    /*
     *  description: Clean data in the structs
     */
    func initStructs() {
        SomeManager.init()
        listInfo = [JSON]()
        listImage = [JSON]()
        urlArray = [String]()
        images = [UIImage]()
    }
}

