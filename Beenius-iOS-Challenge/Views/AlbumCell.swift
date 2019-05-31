//
//  AlbumCell.swift
//  Beenius-iOS-Challenge
//
//  Created by Klemen Košir on 31/05/2019.
//  Copyright © 2019 Klemen Košir. All rights reserved.
//

import UIKit

class AlbumCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    
    var album: Album!
    
    private var thumbnailTask: URLSessionDataTask?
    
    func set(album: Album) {
        self.album = album
        nameLabel.text = album.title
        
        if album.photos == nil {
            album.getPhotos { [weak self] (result) in
                guard let safeSelf = self else { return }
                switch result {
                case .success(let photos):
                    safeSelf.album.photos = photos
                    safeSelf.loadThumbnail()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func loadThumbnail() {
        guard let photos = album.photos else {
            return
        }
        let randomPhoto = photos[Int.random(in: 0..<photos.count)]
        thumbnailTask?.suspend()
        thumbnailTask = URLSession.shared.dataTask(with: randomPhoto.thumbnailUrl, completionHandler: { [weak self] (data, response, error) in
            guard let safeSelf = self else { return }
            if let d = data,
                let image = UIImage(data: d) {
                DispatchQueue.main.async {
                    safeSelf.thumbnailImageView.image = image
                }
            }
        })
        thumbnailTask?.resume()
    }

}
