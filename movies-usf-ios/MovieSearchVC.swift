//
//  MovieSearchVC.swift
//  movies-usf-ios
//
//  Created by Kaushik Gopal on 9/11/19.
//  Copyright © 2019 Kaushik Gopal. All rights reserved.
//

import UIKit

class MovieSearchVC: UIViewController {

    let sQuery = UITextField()
    let srImage = UIImageView()
    let srTitle = UITextView()
    let srGenre = UITextField()
    let srPlot = UITextView()
    let srRating1 = UITextField()
    let srRating2 = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black

        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // open with keyboard open
        // sQuery.becomeFirstResponder()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // on touching anywhere outside of search view, hide keyboard
        view.endEditing(true)
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

        // let imageURL = URL(string: "https://i.ytimg.com/vi/07So_lJQyqw/maxresdefault.jpg")!
        // srImage.load(url: imageURL)

        // setup search result name
        srTitle.textColor = .white
        srTitle.backgroundColor = .clear
        srTitle.font = UIFont.boldSystemFont(ofSize: 22)
        srTitle.isScrollEnabled = false
        srTitle.sizeToFit()

        srTitle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(srTitle)
        NSLayoutConstraint.activate([
            srTitle.topAnchor.constraint(equalTo: srImage.topAnchor),
            srTitle.leadingAnchor.constraint(equalTo: srImage.trailingAnchor, constant: 12),
            srTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])

         srTitle.text = "Movie Title (YYYY)"

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

        srGenre.text = "Action, Horror, Sci-Fi"

        // setup search result plot
        srPlot.textColor = .gray
        srPlot.backgroundColor = .clear
        srPlot.font = UIFont.systemFont(ofSize: 16)

        srPlot.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(srPlot)
        NSLayoutConstraint.activate([
            srPlot.topAnchor.constraint(equalTo: srGenre.bottomAnchor),
            srPlot.bottomAnchor.constraint(equalTo: srImage.bottomAnchor),
            srPlot.leadingAnchor.constraint(equalTo: srTitle.leadingAnchor),
            srPlot.trailingAnchor.constraint(equalTo: srTitle.trailingAnchor)
        ])

        srPlot.text = "A half-vampire, half-mortal man becomes a protector of the mortal race, while slaying evil vampires."

        // setup search result ratings
        srRating1.textColor = .yellow
        srRating1.font = UIFont.boldSystemFont(ofSize: 18)

        srRating1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(srRating1)
        NSLayoutConstraint.activate([
            srRating1.topAnchor.constraint(equalTo: srImage.bottomAnchor, constant: 10),
            srRating1.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        srRating1.text = "IMDB :   7.1/10"

        srRating2.textColor = .yellow
        srRating2.font = UIFont.boldSystemFont(ofSize: 18)

        srRating2.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(srRating2)
        NSLayoutConstraint.activate([
            srRating2.topAnchor.constraint(equalTo: srRating1.bottomAnchor, constant: 8),
            srRating2.trailingAnchor.constraint(equalTo: srRating1.trailingAnchor)
        ])

        srRating2.text = "Rotten T :      81%"
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
