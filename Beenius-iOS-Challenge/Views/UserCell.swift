//
//  UserCell.swift
//  Beenius-iOS-Challenge
//
//  Created by Klemen Košir on 31/05/2019.
//  Copyright © 2019 Klemen Košir. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    
    func set(user: User) {
        nameLabel.text = user.name
        usernameLabel.text = user.username
        emailLabel.text = user.email
    }

}
