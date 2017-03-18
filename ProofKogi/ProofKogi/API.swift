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
    
    var method: HTTPMethod {
        switch self {
            
        case .search:
            return .get
            
        }
    }
    
    var path: String {
        switch  self {
            
        case .search:
            return "search"
            
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
        default:
            return urlRequest
        }
    }
}
