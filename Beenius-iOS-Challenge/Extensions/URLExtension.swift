//
//  URLExtension.swift
//  Beenius-iOS-Challenge
//
//  Created by Klemen Košir on 31/05/2019.
//  Copyright © 2019 Klemen Košir. All rights reserved.
//

import Foundation

extension URL {
    
    @discardableResult
    mutating func makeSafe() -> Bool {
        guard var comps = URLComponents(url: self, resolvingAgainstBaseURL: false) else { return false }
        comps.scheme = "https"
        guard let safeUrl = comps.url else { return false }
        self = safeUrl
        return true
    }
    
    var safeURL: URL? {
        guard var comps = URLComponents(url: self, resolvingAgainstBaseURL: false) else { return nil }
        comps.scheme = "https"
        guard let safeUrl = comps.url else { return nil }
        return safeUrl
    }
    
}
