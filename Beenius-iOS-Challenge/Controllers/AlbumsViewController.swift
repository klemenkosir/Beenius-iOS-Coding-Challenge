//
//  AlbumsViewController.swift
//  Beenius-iOS-Challenge
//
//  Created by Klemen Košir on 31/05/2019.
//  Copyright © 2019 Klemen Košir. All rights reserved.
//

import UIKit

class AlbumsViewController: UITableViewController {

    private var albums: [Album] = []
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAlbums()
    }
    
    private func loadAlbums() {
        Album.getAlbums(for: user.id) { [weak self] result in
            guard let safeSelf = self else { return }
            switch result {
            case .success(let albums):
                safeSelf.albums = albums
                safeSelf.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PhotosViewController,
            let selectedCell = sender as? AlbumCell {
            destination.album = selectedCell.album
        }
    }

}

extension AlbumsViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath) as! AlbumCell
        cell.set(album: albums[indexPath.row])
        return cell
    }
    
}
