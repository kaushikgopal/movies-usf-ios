//
//  MovieSearchVC.swift
//  movies-usf-ios
//
//  Created by Kaushik Gopal on 9/11/19.
//  Copyright © 2019 Kaushik Gopal. All rights reserved.
//

import UIKit
import RxSwift
import NotificationBannerSwift

class MovieSearchVC: UIViewController {

    private let sQuery = UITextField()
    
    private let srInfoCell = BookmarkCell()
    private let srRating1 = UITextField()
    private let srRating2 = UITextField()
    
    private let viewModel: MovieSearchVM
    private let dbag = DisposeBag()
    private var banner: NotificationBanner? = nil

    init(_ movieRepo: MovieRepository) {
        self.viewModel = MovieSearchVM(repo: movieRepo)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        
        setupUI()
        bindViewState()
        bindViewEffects()
        bindUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // open with keyboard open
        // sQuery.becomeFirstResponder()
        
        viewModel.processViewEvent(event: .screenLoad)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // on touching anywhere outside of search view, hide keyboard
        view.endEditing(true)
    }

    // MARK: Private helper functions

    private func bindUI() {
        sQuery.addTarget(self, action: #selector(searchPressed), for: .editingDidEndOnExit)
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        srInfoCell.bind(clickListener: imageTap)
    }
    
    @objc private func searchPressed() {
        viewModel.processViewEvent(event: .searchMovie(sQuery.text ?? ""))
    }

    @objc private func imageTapped() {
        viewModel.processViewEvent(event: .toggleMovie(srInfoCell.movieTitleView.text ?? ""))
    }

    private func bindViewState() {
        viewModel.viewState
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] vs in
                    self?.srInfoCell.bind(
                        posterUrl: vs.moviePosterUrl,
                        title: vs.movieTitle,
                        genreInfo: vs.genres,
                        plotSummary: vs.plot
                    )
                    
                    self?.srRating1.text = vs.rating1
                    self?.srRating2.text = vs.rating2
                },
                onError: { err in
                    print("🛠 we got an error \(err)")
                }
            )
            .disposed(by: dbag)
    }
    
    private func bindViewEffects() {
        viewModel.viewEffects
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] ve in
                    switch ve {
                    case .addedBookmark(let (text)):
                        self?.banner?.dismiss()
                        self?.banner = NotificationBanner(title: text, style: .success)
                        self?.banner?.show()
                    case .removedBookmark(let (text)):
                        self?.banner?.dismiss()
                        self?.banner = NotificationBanner(title: text, style: .warning)
                        self?.banner?.show()
                    case .noEffect:
                        print("no effect")
                    }
                },
                onError: { err in
                    print("🛠 we got an error \(err)")
                }
            )
            .disposed(by: dbag)
    }
    
    private func setupUI() {

        // setup search query view
        sQuery.attributedPlaceholder = NSAttributedString(
            string: "Search a Movie...",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        sQuery.returnKeyType = UIReturnKeyType.search
        sQuery.textColor = .white
        sQuery.font = UIFont.boldSystemFont(ofSize: 28)

        view.addSubview(sQuery)
        
        sQuery.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sQuery.topAnchor.constraint(equalTo: view.topAnchor, constant: 64),
            sQuery.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sQuery.heightAnchor.constraint(equalToConstant: 64)
        ])
        
        // setup search result view
        
        view.addSubview(srInfoCell)
        
        srInfoCell.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            srInfoCell.topAnchor.constraint(equalTo: sQuery.bottomAnchor, constant: 10),
            srInfoCell.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            srInfoCell.heightAnchor.constraint(equalToConstant: BookmarkCell.HEIGHT),
            srInfoCell.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        // setup search result ratings
        srRating1.textColor = .yellow
        srRating1.font = UIFont.boldSystemFont(ofSize: 18)

        srRating1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(srRating1)
        NSLayoutConstraint.activate([
            srRating1.topAnchor.constraint(equalTo: srInfoCell.bottomAnchor, constant: 10),
            srRating1.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        srRating2.textColor = .yellow
        srRating2.font = UIFont.boldSystemFont(ofSize: 18)

        srRating2.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(srRating2)
        NSLayoutConstraint.activate([
            srRating2.topAnchor.constraint(equalTo: srRating1.bottomAnchor, constant: 8),
            srRating2.trailingAnchor.constraint(equalTo: srRating1.trailingAnchor)
        ])
    }
}
