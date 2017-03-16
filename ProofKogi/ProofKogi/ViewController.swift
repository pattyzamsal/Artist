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
        
        let param = [
            "q": artistField.text!,
            "type": "artist",
            ] as [String : Any]
        
        print(param)
        
        Alamofire.request(Router.search(param as [String : AnyObject]))
            .validate()
            .responseJSON { response in
                
                print(response.debugDescription)
                
                if response.result.isSuccess{
                    
                    print("success")
                    
                } else {
                    
                    print(response.debugDescription)
                    self.throwBasicAlert("Error", message: NSLocalizedString("Error buscando al artista", comment: ""), actions: [
                        ("Ok", { action in })
                        ])
                    
                }
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == artistField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func throwBasicAlert(_ title: String, message: String, actions: [(String, (UIAlertAction?) -> Void)]) {
        let alertController = UIAlertController(title: title, message: message as String, preferredStyle: .alert)
        for (actionTitle, actionHandler) in actions {
            alertController.addAction(UIAlertAction(title: actionTitle, style: .default, handler: actionHandler))
        }
        //Present the AlertController
        self.present(alertController, animated: true, completion: nil)
    }
    
    func handleSingleTap(_ recognizer: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
}

