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
    
    var idArtist = ""
    var nameArtist = ""
    var listURLImages = [String]()
    var listImages = [UIImage]()
    var popularity = 0
    var followers = 0
    
    static let sharedInstance = SomeManager()

}
