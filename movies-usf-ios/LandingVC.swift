//
//  LandingVC.swift
//  movies-usf-ios
//
//  Created by Kaushik Gopal on 9/4/19.
//  Copyright © 2019 Kaushik Gopal. All rights reserved.
//

import UIKit

class LandingVC: UIViewController {

//    let btnSearch = UIButton()
    let btnGenreChecklist = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red

        setupButtons()
    }
    
    func setupButtons() {
        btnGenreChecklist.backgroundColor = .white
        btnGenreChecklist.setTitleColor(.red, for: .normal)
        btnGenreChecklist.setTitle("Pick Genres", for:.normal)
        view.addSubview(btnGenreChecklist)
        
        // constraints
        
        btnGenreChecklist.translatesAutoresizingMaskIntoConstraints = false // use Auto Layout
        btnGenreChecklist.leadingAnchor.constraint(
            equalTo: view.leadingAnchor,
            constant: 20
        ).isActive = true // activate the constraint
        btnGenreChecklist.trailingAnchor.constraint(
            equalTo: view.trailingAnchor,
            constant: -20
        ).isActive = true
        btnGenreChecklist.heightAnchor.constraint(
            equalToConstant: 50
        ).isActive = true
        btnGenreChecklist.centerYAnchor.constraint(
            equalTo: view.centerYAnchor
        ).isActive = true
    }
    
}
