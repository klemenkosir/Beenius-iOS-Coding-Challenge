//
//  PhotoCell.swift
//  Beenius-iOS-Challenge
//
//  Created by Klemen Košir on 31/05/2019.
//  Copyright © 2019 Klemen Košir. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var photoTitleLabel: UILabel!
    
    var photo: Photo!
    
    func set(photo: Photo) {
        self.photo = photo
        photoImageView.image = nil
        photoImageView.load(photo.thumbnailUrl)
        photoTitleLabel.text = photo.title
    }
    
}
