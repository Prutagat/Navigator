//
//  PostsViewController.swift
//  Navigation
//
//  Created by Алексей Голованов on 15.11.2023.
//

import UIKit
import SnapKit

final class PostsViewController: UIViewController {
    
    static var postsTableView: UITableView =  {
        let tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
}
