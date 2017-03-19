//
//  ArtistInfo.swift
//  ProofKogi
//
//  Created by Patricia Zambrano on 3/18/17.
//  Copyright © 2017 Patricia Zambrano. All rights reserved.
//

import UIKit

class ArtistInfo: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    
    var nameArtist = ""
    
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
        nameLabel.text = NSLocalizedString("Artist: ", comment: "") + SomeManager.sharedInstance.nameArtist
        followersLabel.text = NSLocalizedString("Followers: ", comment: "") + SomeManager.sharedInstance.followers.description
        popularityLabel.text = NSLocalizedString("Popularity: ", comment: "") + SomeManager.sharedInstance.popularity.description
        artistImage.image = SomeManager.sharedInstance.listImages[0]
        self.tableView.reloadData()
        
        self.throwBasicAlert("", message: NSLocalizedString("Press to the album's name for more information", comment: ""), actions: [
            ("Ok", { action in
                self.tableView.reloadData()
            })
            ])
    }
    
    func goBack(){
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    //****************
    //
    //  TableView
    //
    //***************
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SomeManager.sharedInstance.listAlbums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath) as! AlbumCell
        
        if indexPath.row < SomeManager.sharedInstance.listImagesAlbums.count {
            cell.albumImage.image = SomeManager.sharedInstance.listImagesAlbums[indexPath.row]
            cell.albumMarkets.text = NSLocalizedString("Markets: ", comment: "") + SomeManager.sharedInstance.listMarkets[indexPath.row]
            cell.albumName.text = SomeManager.sharedInstance.listAlbums[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let urlAlbum = SomeManager.sharedInstance.listURLAlbums[indexPath.row]
        UIApplication.shared.openURL(NSURL(string: urlAlbum) as! URL)
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
}
