//
//  BookmarkCell.swift
//  movies-usf-ios
//
//  Created by Kaushik Gopal on 10/13/19.
//  Copyright © 2019 Kaushik Gopal. All rights reserved.
//

import UIKit

class BookmarkCell: UITableViewCell {

    static let HEIGHT = 200
    
    var moviePoster = UIImageView()
    var movieTitle = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupPosterView()
        setupTitleView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPosterView() {
        addSubview(moviePoster)
        moviePoster.layer.cornerRadius = 5
        moviePoster.clipsToBounds = true
        
        moviePoster.translatesAutoresizingMaskIntoConstraints = false
        moviePoster.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        moviePoster.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        moviePoster.heightAnchor.constraint(equalToConstant: CGFloat(BookmarkCell.HEIGHT - 20)).isActive = true
        moviePoster.widthAnchor.constraint(equalTo: moviePoster.heightAnchor, multiplier: 1/1.5).isActive = true
    }
    
    private func setupTitleView() {
        addSubview(movieTitle)
        movieTitle.numberOfLines = 0
        movieTitle.adjustsFontSizeToFitWidth = true
        
        movieTitle.translatesAutoresizingMaskIntoConstraints = false
        movieTitle.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        movieTitle.leadingAnchor.constraint(equalTo: moviePoster.trailingAnchor, constant: 20).isActive = true
        movieTitle.heightAnchor.constraint(equalToConstant: CGFloat(BookmarkCell.HEIGHT - 20)).isActive = true
        movieTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
    }
}
