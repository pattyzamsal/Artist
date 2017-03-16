//
//  API.swift
//  ProofKogi
//
//  Created by Patricia Zambrano on 3/15/17.
//  Copyright © 2017 Patricia Zambrano. All rights reserved.
//

import Foundation
import Alamofire

enum Router : URLRequestConvertible {
    static var baseURLString = "https://api.spotify.com/v1/"
    
    static var params = [Any]()t
    
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
    
    func asURLRequest() throws -> URLRequest {
        
        let URL = try Router.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: URL.appendingPathComponent(path))
        URLRequest.httpMethod = method.rawValue
        
        switch  self {
            
        case .search(let parameters):
            return try JSONEncoding.default.encode(urlRequest, with: parameters)
        default:
            urlRequest
        }
    }
}
