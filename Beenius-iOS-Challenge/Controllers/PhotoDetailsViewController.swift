//
//  PhotoDetailsViewController.swift
//  Beenius-iOS-Challenge
//
//  Created by Klemen Košir on 31/05/2019.
//  Copyright © 2019 Klemen Košir. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var photoNameLabel: UILabel!
    @IBOutlet private weak var albumNameLabel: UILabel!
    @IBOutlet private weak var userLabel: UILabel!
    @IBOutlet private weak var bottomViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bottomView: UIView!
    
    var photo: Photo!
    
    private var overlayVisible = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.load(photo.url)
        photoNameLabel.text = photo.title
        albumNameLabel.text = photo.parentAlbum?.title
        userLabel.text = photo.parentAlbum?.parentUser?.name
    }

    @IBAction func tapGestureHandler(_ sender: Any) {
        overlayVisible = !overlayVisible
        self.navigationController?.setNavigationBarHidden(!overlayVisible, animated: true)
        UIView.animate(withDuration: 0.2) {
            if self.overlayVisible {
                self.bottomViewBottomConstraint.constant = 0
            }
            else {
                self.bottomViewBottomConstraint.constant = -self.bottomView.frame.size.height
            }
            self.view.layoutIfNeeded()
        }
    }
}
