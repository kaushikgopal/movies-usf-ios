//
//  MovieBucketListVC.swift
//  movies-usf-ios
//
//  Created by Kaushik Gopal on 9/11/19.
//  Copyright © 2019 Kaushik Gopal. All rights reserved.
//

import UIKit

class MovieBookmarksVC: UIViewController {

    var tableView = UITableView()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        // table view
        view.addSubview(tableView)
        registerTableViewDelegates()
        tableView.rowHeight = 100
        tableView.backgroundColor = UIColor.black
        tableView.pin(to: view)
    }
}

extension MovieBookmarksVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func registerTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }

}
