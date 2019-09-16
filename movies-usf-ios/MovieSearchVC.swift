//
//  MovieSearchVC.swift
//  movies-usf-ios
//
//  Created by Kaushik Gopal on 9/11/19.
//  Copyright © 2019 Kaushik Gopal. All rights reserved.
//

import UIKit

class MovieSearchVC: UIViewController {

    let searchName = UITextField()
    let srImage = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black

        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // open with keyboard open
        // searchName.becomeFirstResponder()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // on touching anywhere outside of search view, hide keyboard
        view.endEditing(true)
    }

    private func setupUI() {

        // setup search text
        searchName.attributedPlaceholder = NSAttributedString(
            string: "Search a Movie...",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        searchName.returnKeyType = UIReturnKeyType.search
        searchName.textColor = .white
        searchName.font = UIFont.boldSystemFont(ofSize: 28)

        searchName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchName)
        NSLayoutConstraint.activate([
            searchName.topAnchor.constraint(equalTo: view.topAnchor, constant: 64),
            searchName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchName.heightAnchor.constraint(equalToConstant: 64)
        ])

        // setup search result
        srImage.backgroundColor = .red
        srImage.contentMode = .scaleAspectFit

        srImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(srImage)
        NSLayoutConstraint.activate([
            srImage.topAnchor.constraint(equalTo: searchName.bottomAnchor, constant: 12),
            srImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            srImage.heightAnchor.constraint(equalToConstant: 192),
            srImage.widthAnchor.constraint(equalToConstant: 128)
        ])

//        let imageURL = URL(string: "https://i.ytimg.com/vi/07So_lJQyqw/maxresdefault.jpg")!
//        srImage.load(url: imageURL)
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
