//
//  NetworkRequest.swift
//  Beenius-iOS-Challenge
//
//  Created by Klemen Košir on 31/05/2019.
//  Copyright © 2019 Klemen Košir. All rights reserved.
//

import Foundation

enum NetworkRequest {
    
    static let baseURL = "https://jsonplaceholder.typicode.com"
    static let apiURL = ""
    
    case getUsers
    case getAlbums(userId: Int)
    case getPhotos(albumId: Int)
    
    enum Method: String {
        case post, get, put, delete
    }
    
    var url: URL {
        switch self {
        default:
            return URL(string: NetworkRequest.baseURL + NetworkRequest.apiURL + self.endpointPath)!
        }
    }
    
    var endpointPath: String {
        var ep = ""
        switch self {
        case .getUsers:
            ep = "/users"
        case .getAlbums(let userId):
            ep = "/albums?userId=\(userId)"
        case .getPhotos(let albumId):
            ep = "/photos?albumId=\(albumId)"
        }
        return ep.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    
    var httpMethod: Method {
        switch self {
        default:
            return .get
        }
    }
    
    var headerFields: [String: String] {
        var headers = [String: String]()
        
        headers["Content-Type"] = "application/json"
        
        return headers
    }
    
    var httpBody: Data? {
        var bodyDict = [String: Any]()
        
        switch self {
        default:
            return nil
        }
        
        return try? JSONEncoder().encode(bodyDict.mapValues({ String(describing: $0) }))
    }
}
