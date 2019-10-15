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
        
        setupTableView()
        registerTableViewDelegates()
    }

    private func setupTableView() {
        // table view
        view.addSubview(tableView)
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: BookmarkCell.IDENTIFIER) as! BookmarkCell
//        cell.bind(content: )
        return cell
    }
    
    private func registerTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BookmarkCell.self, forCellReuseIdentifier: BookmarkCell.IDENTIFIER)
    }
}
