//
//  UIImageViewExtension.swift
//  Beenius-iOS-Challenge
//
//  Created by Klemen Košir on 31/05/2019.
//  Copyright © 2019 Klemen Košir. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func load(_ url: URL?, _ placeholder: UIImage? = nil, completion: (() -> Void)? = nil) {
        guard let url = url?.safeURL else {
            return
        }
        ImageDownloader.shared.downloadImage(url: url, size: self.frame.size) { [weak self] (image) in
            DispatchQueue.main.syncMainSafe {
                self?.image = image
                completion?()
            }
        }
    }
    
}
