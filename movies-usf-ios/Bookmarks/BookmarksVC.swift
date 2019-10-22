//
//  MovieBucketListVC.swift
//  movies-usf-ios
//
//  Created by Kaushik Gopal on 9/11/19.
//  Copyright © 2019 Kaushik Gopal. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BookmarksVC: UIViewController {

    private let repo: MovieRepository
    private let vm: BookmarksVM
    private let dbag = DisposeBag()

    private var bookmarksTableView = UITableView()
    private var vs: BookmarksVM.ViewState? = nil

    init(_ movieRepo: MovieRepository) {
        self.vm = BookmarksVM(repo: movieRepo)
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
        bindViewState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        vm.processViewEvent(event: .viewResume)
    }
    
    private func setupTableView() {
        // table view
        view.addSubview(bookmarksTableView)
        
        bookmarksTableView.rowHeight = BookmarkCell.HEIGHT
        bookmarksTableView.backgroundColor = UIColor.black
        bookmarksTableView.pin(to: view)
    }
}

extension BookmarksVC {
    private func bindViewState() {
        vm.viewState
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .do(onError: { err in
                print("🛠 BookmarksVC: we got an error \(err)")
            })
            .map { $0.bookmarks }
            .bind(to: bookmarksTableView.rx.items(
                    cellIdentifier: BookmarkCell.IDENTIFIER,
                    cellType: BookmarkCell.self
            )){ (row, element, cell) in
                cell.bind(
                    posterUrl: element.posterUrl,
                    title: element.title,
                    genreInfo: element.genre,
                    plotSummary: element.plot
                )
            }
            .disposed(by: dbag)
    }
}

extension BookmarksVC: UITableViewDelegate {
    private func registerTableViewDelegates() {
        bookmarksTableView.delegate = self
        bookmarksTableView.register(BookmarkCell.self, forCellReuseIdentifier: BookmarkCell.IDENTIFIER)
    }
}
