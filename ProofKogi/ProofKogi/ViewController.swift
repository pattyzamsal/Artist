//
//  ViewController.swift
//  ProofKogi
//
//  Created by Patricia Zambrano on 3/15/17.
//  Copyright © 2017 Patricia Zambrano. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class ViewController: UIViewController, UITextFieldDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBOutlet weak var artistField: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let singleFingerTap = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleSingleTap(_:)))
        self.view.addGestureRecognizer(singleFingerTap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchAction(_ sender: UIButton) {
        SVProgressHUD.show(withStatus: "Buscando")
        
        var param = [String : Any]()
        
        param = [
            "artists":artistField.text!,
            "type":"artists",
        ]
        
        print(param)
        
        Alamofire.request(Router.search(param as [String : AnyObject]))
            .validate()
            .responseJSON { response in
                
                print(response)
                
                if response.result.isSuccess{
                    
                    print("success")
                    
                } else {
                    
                    var errorMessage = ""
                    if let data = response.data {
                        // Print message
                        let responseJSON = JSON(data: data)
                        
                        if !responseJSON["error"]["message"].stringValue.isEmpty {
                            errorMessage += responseJSON["error"]["message"].stringValue
                        }
                        
                    }
                    
                    SVProgressHUD.showError(withStatus: errorMessage)
                    
                }
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == artistField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func handleSingleTap(_ recognizer: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
}

