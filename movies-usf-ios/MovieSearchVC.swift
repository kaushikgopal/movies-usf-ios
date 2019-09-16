//
//  MovieSearchVC.swift
//  movies-usf-ios
//
//  Created by Kaushik Gopal on 9/11/19.
//  Copyright © 2019 Kaushik Gopal. All rights reserved.
//

import UIKit
import RxSwift

class MovieSearchVC: UIViewController {

    private let sQuery = UITextField()
    private let srImage = UIImageView()
    private let srTitle = UITextView()
    private let srGenre = UITextField()
    private let srPlot = UITextView()
    private let srRating1 = UITextField()
    private let srRating2 = UITextField()
    
    private let viewModel = MovieSearchVM()
    private let dbag = DisposeBag()

    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        
        setupUI()
        bindViewState()
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
    }
    
    @objc private func searchPressed() {
        viewModel.processViewEvent(event: .searchMovie(sQuery.text ?? ""))
    }
    
    private func bindViewState() {
        viewModel.viewState
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] vs in
                    self?.srImage.load(imageUrl: vs.moviePosterUrl)
                    self?.srTitle.text = vs.movieTitle
                    self?.srGenre.text = vs.genres
                    self?.srPlot.text = vs.plot
                    self?.srRating1.text = vs.rating1
                    self?.srRating2.text = vs.rating2
                },
                onError: { err in
                    print(" we got an error \(err)")
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

        sQuery.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sQuery)
        NSLayoutConstraint.activate([
            sQuery.topAnchor.constraint(equalTo: view.topAnchor, constant: 64),
            sQuery.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sQuery.heightAnchor.constraint(equalToConstant: 64)
        ])

        // setup search result image
        srImage.backgroundColor = .darkGray
        srImage.contentMode = .scaleAspectFit

        srImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(srImage)
        NSLayoutConstraint.activate([
            srImage.topAnchor.constraint(equalTo: sQuery.bottomAnchor, constant: 12),
            srImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            srImage.heightAnchor.constraint(equalToConstant: 192),
            srImage.widthAnchor.constraint(equalToConstant: 128)
        ])

        // setup search result name
        srTitle.textColor = .white
        srTitle.backgroundColor = .clear
        srTitle.font = UIFont.boldSystemFont(ofSize: 22)
        srTitle.isScrollEnabled = false
        srTitle.isEditable = false
        srTitle.sizeToFit()

        srTitle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(srTitle)
        NSLayoutConstraint.activate([
            srTitle.topAnchor.constraint(equalTo: srImage.topAnchor),
            srTitle.leadingAnchor.constraint(equalTo: srImage.trailingAnchor, constant: 12),
            srTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])

        // setup search result genres
        srGenre.textColor = .green
        srGenre.font = UIFont.systemFont(ofSize: 16)

        srGenre.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(srGenre)
        NSLayoutConstraint.activate([
            srGenre.topAnchor.constraint(equalTo: srTitle.bottomAnchor),
            srGenre.leadingAnchor.constraint(equalTo: srTitle.leadingAnchor, constant: 6),
            srGenre.trailingAnchor.constraint(equalTo: srTitle.trailingAnchor)
        ])

        // setup search result plot
        srPlot.textColor = .gray
        srPlot.backgroundColor = .clear
        srPlot.isEditable = false
        srPlot.font = UIFont.systemFont(ofSize: 16)

        srPlot.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(srPlot)
        NSLayoutConstraint.activate([
            srPlot.topAnchor.constraint(equalTo: srGenre.bottomAnchor),
            srPlot.bottomAnchor.constraint(equalTo: srImage.bottomAnchor),
            srPlot.leadingAnchor.constraint(equalTo: srTitle.leadingAnchor),
            srPlot.trailingAnchor.constraint(equalTo: srTitle.trailingAnchor)
        ])

        // setup search result ratings
        srRating1.textColor = .yellow
        srRating1.font = UIFont.boldSystemFont(ofSize: 18)

        srRating1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(srRating1)
        NSLayoutConstraint.activate([
            srRating1.topAnchor.constraint(equalTo: srImage.bottomAnchor, constant: 10),
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

extension UIImageView {
    func load(imageUrl: String?) {
        
        if imageUrl == nil {
            self.image = nil
            self.backgroundColor = .lightGray
            return
        }
        
        let url = URL(string: imageUrl!)!
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        self?.backgroundColor = .darkGray
                    }
                }
            }
        }
    }
}
