//
//  PhotosViewController.swift
//  Beenius-iOS-Challenge
//
//  Created by Klemen Košir on 31/05/2019.
//  Copyright © 2019 Klemen Košir. All rights reserved.
//

import UIKit

class PhotosViewController: UICollectionViewController {

    var album: Album!
    
    private var photos: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPhotos()
    }
    
    private func loadPhotos() {
        if let p = album.photos {
            photos = p
            collectionView.reloadData()
        }
        else {
            album.getPhotos { [weak self] (result) in
                guard let safeSelf = self else { return }
                switch result {
                case .success(let photos):
                    safeSelf.album.photos = photos
                    safeSelf.photos = photos
                    safeSelf.collectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PhotoDetailsViewController,
            let selectedCell = sender as? PhotoCell,
            var photo = selectedCell.photo {
            photo.parentAlbum = album
            destination.photo = photo
        }
    }

}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        cell.set(photo: photos[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat
        if UIScreen.main.bounds.width > 320 {
            width = collectionView.frame.size.width/3-1.5
        }
        else {
            // on smaller screens we show just two photos per row
            width = collectionView.frame.size.width/2-1
        }
        return CGSize(width: width, height: width)
    }
    
}
