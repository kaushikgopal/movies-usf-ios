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

        // use Auto Layout
        searchName.translatesAutoresizingMaskIntoConstraints = false
        searchName.attributedPlaceholder = NSAttributedString(
            string: "Search a Movie...",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        searchName.returnKeyType = UIReturnKeyType.search
        searchName.textColor = .white
        searchName.font = UIFont.boldSystemFont(ofSize: 28)

        view.addSubview(searchName)
        NSLayoutConstraint.activate([
            searchName.topAnchor.constraint(equalTo: view.topAnchor, constant: 64),
            searchName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchName.heightAnchor.constraint(equalToConstant: 64)
        ])
    }
}
