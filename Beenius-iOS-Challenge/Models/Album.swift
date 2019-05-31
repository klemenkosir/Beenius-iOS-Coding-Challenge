//
//  Album.swift
//  Beenius-iOS-Challenge
//
//  Created by Klemen Košir on 31/05/2019.
//  Copyright © 2019 Klemen Košir. All rights reserved.
//

import Foundation

struct Album: Decodable {
    
    let id: Int
    let title: String
    
    var photos: [Photo]?
    
}

extension Album {
    
    func getPhotos(_ completion: @escaping (Result<[Photo], Error>) -> Void) {
        NetworkingManager.shared.makeRequest(NetworkRequest.getPhotos(albumId: self.id)) { (result: Result<[Photo], Error>) in
            switch result {
            case .success(let p):
                break
            default:
                break
            }
            completion(result)
        }
    }
    
}

extension Album {
    
    static func getAlbums(for userId: Int, _ completion: @escaping (Result<[Album], Error>) -> Void) {
        NetworkingManager.shared.makeRequest(NetworkRequest.getAlbums(userId: userId), completion: completion)
    }
    
}
