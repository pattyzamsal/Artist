//
//  ArtistInfo.swift
//  ProofKogi
//
//  Created by Patricia Zambrano on 3/18/17.
//  Copyright © 2017 Patricia Zambrano. All rights reserved.
//

import UIKit

class ArtistInfo: UIViewController {

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
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
