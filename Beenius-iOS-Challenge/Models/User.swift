//
//  User.swift
//  Beenius-iOS-Challenge
//
//  Created by Klemen Košir on 31/05/2019.
//  Copyright © 2019 Klemen Košir. All rights reserved.
//

import Foundation

struct User: Decodable {
    
    let id: Int
    let name: String
    let username: String
    let email: String
    
}

extension User {
    
    static func getUsers(_ completion: @escaping (Result<[User], Error>) -> Void) {
        NetworkingManager.shared.makeRequest(NetworkRequest.getUsers, completion: completion)
    }
    
}
