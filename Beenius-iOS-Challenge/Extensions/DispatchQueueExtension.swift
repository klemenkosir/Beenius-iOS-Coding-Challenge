//
//  DispatchQueueExtension.swift
//  Beenius-iOS-Challenge
//
//  Created by Klemen Košir on 31/05/2019.
//  Copyright © 2019 Klemen Košir. All rights reserved.
//

import Foundation

extension DispatchQueue {
    
    func syncMainSafe(_ block: () -> Void) {
        if Thread.isMainThread {
            block()
        }
        else {
            DispatchQueue.main.sync {
                block()
            }
        }
    }
    
}
