//
//  MovieBucketListVC.swift
//  movies-usf-ios
//
//  Created by Kaushik Gopal on 9/11/19.
//  Copyright © 2019 Kaushik Gopal. All rights reserved.
//

import UIKit

class BookmarksVC: UIViewController {
    init(_ movieRepo: MovieRepository) {
        // self.viewModel = MovieSearchVM(repo: movieRepo)
        self.repo = movieRepo
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
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
        
        tableView.rowHeight = BookmarkCell.HEIGHT
        tableView.backgroundColor = UIColor.black
        tableView.pin(to: view)
    }
    
    private var tableView = UITableView()
    private let repo: MovieRepository
}

extension BookmarksVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repo.bookmarkCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func registerTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}
