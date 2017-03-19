//
//  API.swift
//  ProofKogi
//
//  This script realize the connection to the endpoints
//
//  Created by Patricia Zambrano on 3/15/17.
//  Copyright © 2017 Patricia Zambrano. All rights reserved.
//

import Foundation
import Alamofire

enum Router : URLRequestConvertible {
    static var baseURLString = "https://api.spotify.com/v1/"
    
    static var token: String?
    static var params = [Any]()
    
    // Search
    case search([String : AnyObject])
    
    // Albums
    case albums(String)
    
    var method: HTTPMethod {
        switch self {
            
        case .search:
            return .get
            
        case .albums:
            return .get
        }
    }
    
    var path: String {
        switch  self {
            
        case .search:
            return "search"
        
        case .albums(let param):
            return "artists/\(param)/albums"

        default:
            return ""
            
        }
    }
    
    /*
     *  description: function that realize the encoding of the url
     */
    func asURLRequest() throws -> URLRequest {
        
        let URL = try Router.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: URL.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        if let token = Router.token {
            urlRequest.setValue("\(token)", forHTTPHeaderField: "Authorization")
        }
        
        switch  self {
            
            case .search(let parameters):
                return try URLEncoding.default.encode(urlRequest, with: parameters)
            
            case .albums:
                let param = ["album_type": "album", "limit": "50",] as [String : Any]
                return try URLEncoding.default.encode(urlRequest, with: param)
            
            default:
                return urlRequest
        }
    }
}
