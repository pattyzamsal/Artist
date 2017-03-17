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

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var artistField: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    
    var listInfo = [JSON]()
    
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     *  description: Action to display when is pressed the search button
     */
    @IBAction func searchAction(_ sender: UIButton) {
        
        SVProgressHUD.show(withStatus: NSLocalizedString("Searching", comment: ""))
        
        if artistField.text! == ""{
            SVProgressHUD.showError(withStatus: NSLocalizedString("Field empty. Try again", comment: ""))
        }
        else{
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
                        
                        print(info)
                        
                        SomeManager.sharedInstance.nameArtist = self.listInfo[0]["name"].stringValue
                        SomeManager.sharedInstance.listImage = self.listInfo[0]["images"].arrayValue
                        
                        SVProgressHUD.showSuccess(withStatus: NSLocalizedString("Successfull search", comment: ""))
                        
                    } else {
                        print(response.debugDescription)
                        SVProgressHUD.showError(withStatus: NSLocalizedString("Error while trying to search the artist", comment: ""))
                    }
            }
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == artistField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    /*
     *  description: Initialize texts of the view
     */
    func initText() {
        artistField.placeholder = NSLocalizedString("Artist", comment: "")
        searchBtn.setTitle(NSLocalizedString("Search", comment: ""), for: UIControlState())
    }
    
    func handleSingleTap(_ recognizer: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
}

