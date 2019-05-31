//
//  UsersViewController.swift
//  Beenius-iOS-Challenge
//
//  Created by Klemen Košir on 31/05/2019.
//  Copyright © 2019 Klemen Košir. All rights reserved.
//

import UIKit

class UsersViewController: UITableViewController {
    
    private var users: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        loadUsers()
    }
    
    private func loadUsers() {
        User.getUsers { [weak self] result in
            guard let safeSelf = self else { return }
            switch result {
            case .success(let users):
                safeSelf.users = users
                safeSelf.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AlbumsViewController,
            let selectedCell = sender as? UserCell {
            destination.userId = selectedCell.user.id
        }
    }

}

extension UsersViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserCell
        cell.set(user: users[indexPath.row])
        return cell
    }
    
}
