//
//  GlobalVars.swift
//  ProofKogi
//
//  Created by Devstn4 on 3/16/17.
//  Copyright © 2017 Patricia Zambrano. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

class SomeManager {
    
    // Search
    var idArtist = ""
    var nameArtist = ""
    var listURLImages = [String]()
    var listImages = [UIImage]()
    var popularity = 0
    var followers = 0
    
    // Albums
    var listAlbums = [String]()
    var listMarkets = [String]()
    var listImagesAlbums = [UIImage]()
    var listURLAlbums = [String]()
    
    static let sharedInstance = SomeManager()

}
