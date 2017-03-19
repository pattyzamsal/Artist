//
//  ArtistView.swift
//  ProofKogi
//
//  Created by Devstn4 on 3/16/17.
//  Copyright © 2017 Patricia Zambrano. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class ArtistView: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var artistLabel: UIButton!
    @IBOutlet weak var ImageCollectionView: UICollectionView!
    
    var nameArtist = ""
    var imageCounter: Int = 0
    
    var listInfo = [JSON]()
    var listImagesURL = [String]()
    var listAlbums = [String]()
    var listURL = [String]()
    var listMarkets = [String]()
    var images = [UIImage]()
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    fileprivate let itemsPerRow: CGFloat = 3
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.throwBasicAlert("", message: NSLocalizedString("Press to the artist's name for more information", comment: ""), actions: [
                ("Ok", { action in
                    self.artistLabel.setTitle(SomeManager.sharedInstance.nameArtist, for: UIControlState())
                    self.ImageCollectionView.reloadData()
                })
            ])
    }
    
    func goBack(){
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func artBtn(_ sender: UIButton) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "ArtistInfo") as! ArtistInfo
        myVC.nameArtist = artistLabel.currentTitle!
        navigationController?.pushViewController(myVC, animated: true)
        
        SVProgressHUD.show(withStatus: NSLocalizedString("Searching albums", comment: ""))

        self.initStruct()
        
        Alamofire.request(Router.albums(SomeManager.sharedInstance.idArtist))
            .validate()
            .responseJSON { response in

                if response.result.isSuccess {
                    let info = (JSON(response.result.value!))["items"].arrayValue
                    //"images, url"
                    self.listInfo = info
                    
                    var j = 0
                    for i in 0..<self.listInfo.count{
                        
                        self.listAlbums.insert(self.listInfo[i]["name"].stringValue, at: j)
                        self.listURL.insert(self.listInfo[i]["external_urls"]["spotify"].debugDescription, at: j)
                        self.listImagesURL.insert(self.listInfo[i]["images"][0]["url"].debugDescription, at: j)
                        
                        if self.listInfo[i]["available_markets"].count <= 5 {
                            var markets = ""
                            for k in 0..<self.listInfo[i]["available_markets"].count {
                                markets += self.listInfo[i]["available_markets"][k].stringValue + "|"
                            }
                            self.listMarkets.insert(markets, at: j)
                        }
                        else {
                            self.listMarkets.insert(NSLocalizedString("Many", comment: ""), at: j)
                        }
                        j += 1
                    }
                    
                    j = 0
                    for i in 0..<self.listImagesURL.count{
                        Alamofire.request(self.listImagesURL[i], method: .get)
                            .responseImage { response in
                                if response.result.isSuccess{
                                    
                                    self.images.insert((response.result.value?.af_imageRoundedIntoCircle())!, at: j)
                                    j += 1
                                    if i == SomeManager.sharedInstance.listURLImages.count - 1{
                                        SomeManager.sharedInstance.listImagesAlbums = self.images
                                    }
                                }
                        }
                    }

                    SomeManager.sharedInstance.listURLAlbums = self.listURL
                    SomeManager.sharedInstance.listAlbums = self.listAlbums
                    SomeManager.sharedInstance.listMarkets = self.listMarkets
                    
                    SVProgressHUD.showSuccess(withStatus: NSLocalizedString("Success", comment: ""))
                    
                    
                } else {
                    print(response.debugDescription)
                    SVProgressHUD.showError(withStatus: NSLocalizedString("Error while trying to obtain albums", comment: ""))
                }

        }
    }
    
    // Simplifies showing an alert controller
    func throwBasicAlert(_ title: String, message: String, actions: [(String, (UIAlertAction?) -> Void)]) {
        let alertController = UIAlertController(title: title, message: message as String, preferredStyle: .alert)
        for (actionTitle, actionHandler) in actions {
            alertController.addAction(UIAlertAction(title: actionTitle, style: .default, handler: actionHandler))
        }
        //Present the AlertController
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    //****************
    //
    //  CollectionView delegate
    //
    //***************
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return SomeManager.sharedInstance.listURLImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell",
                                                      for: indexPath) as! ImageCell
        cell.backgroundColor = UIColor.black

        cell.imageCell.image = SomeManager.sharedInstance.listImages[0]

        // Configure the cell
        return cell
    }
    
    //****************
    //
    //  CollectionViewLayout delegate
    //
    //***************
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func initStruct(){
        SomeManager.sharedInstance.listAlbums = [String]()
        SomeManager.sharedInstance.listURLAlbums = [String]()
        SomeManager.sharedInstance.listMarkets = [String]()
        SomeManager.sharedInstance.listImagesAlbums = [UIImage]()
        
        listInfo = [JSON]()
        listImagesURL = [String]()
        listAlbums = [String]()
        listURL = [String]()
        listMarkets = [String]()
        images = [UIImage]()
    }
}
