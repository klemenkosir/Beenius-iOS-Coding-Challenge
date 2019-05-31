//
//  Photo.swift
//  Beenius-iOS-Challenge
//
//  Created by Klemen Košir on 31/05/2019.
//  Copyright © 2019 Klemen Košir. All rights reserved.
//

import Foundation

struct Photo: Decodable {
    
    let id: Int
    let title: String
    let url: URL
    let thumbnailUrl: URL
    
    var parentAlbum: Album?
    
}
