//
//  LandingVC.swift
//  movies-usf-ios
//
//  Created by Kaushik Gopal on 9/4/19.
//  Copyright © 2019 Kaushik Gopal. All rights reserved.
//

import UIKit

class LandingVC: UITabBarController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray

        setupTabs()
    }

    func setupTabs() {
        let movieSearchTab = MovieSearchVC()
        movieSearchTab.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)

        let movieBucketListTab = MovieBucketListVC()
        movieBucketListTab.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)

        let genrePickerTab = GenrePickerVC()
        genrePickerTab.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)

        viewControllers = [
            movieSearchTab, movieBucketListTab, genrePickerTab
        ]
    }
}
