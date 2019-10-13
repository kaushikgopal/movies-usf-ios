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
    static let IDENTIFIER = "BookmarksVC::BookmarkCell"
    
    let posterImage = UIImageView()
    let movieTitle = UILabel()
    let genreInfo = UILabel()
    let rating1 = UILabel()
    let rating2 = UILabel()
    let plot = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
       backgroundColor = UIColor.black
        
        setupPosterView()
        setupTitleView()
        setupGenreInfoView()
        setupPlotView()
        setupRating1View()
        setupRating2View()
        
        posterImage.load(imageUrl: "https://m.media-amazon.com/images/M/MV5BOTk2NDNjZWQtMGY0Mi00YTY2LWE5MzctMGRhZmNlYzljYTg5XkEyXkFqcGdeQXVyMTAyNjg4NjE0._V1_SX300.jpg")
        movieTitle.text = "Dummy bookmark"
        genreInfo.text = "Horror Comedy"
        rating1.text = "imdb"
        rating2.text = "rotten tomatoes"
        plot.text = "some summary text goes here. lipsum blah blah "
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(content movieResult: MovieSearchResult) {
        posterImage.load(imageUrl: movieResult.posterUrl)
        movieTitle.text = movieResult.title
    }
    
    private func setupPosterView() {
        posterImage.layer.cornerRadius = 5
        posterImage.clipsToBounds = true
        
        addSubview(posterImage)

        posterImage.translatesAutoresizingMaskIntoConstraints = false
        posterImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        posterImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        posterImage.heightAnchor.constraint(equalToConstant: CGFloat(BookmarkCell.HEIGHT - 20)).isActive = true
        posterImage.widthAnchor.constraint(equalTo: posterImage.heightAnchor, multiplier: 1/1.5).isActive = true
    }
    
    private func setupTitleView() {
        
        movieTitle.textColor = .white
        movieTitle.font = UIFont.boldSystemFont(ofSize: 22)
        movieTitle.numberOfLines = 0
        movieTitle.adjustsFontSizeToFitWidth = true
        
        addSubview(movieTitle)

        movieTitle.translatesAutoresizingMaskIntoConstraints = false
        movieTitle.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        movieTitle.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: 20).isActive = true
        movieTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
    }
    
    private func setupGenreInfoView()  {
        genreInfo.textColor = .green
        genreInfo.font = UIFont.systemFont(ofSize: 16)
        genreInfo.numberOfLines = 0
        genreInfo.adjustsFontSizeToFitWidth = true

        addSubview(genreInfo)
        
        genreInfo.translatesAutoresizingMaskIntoConstraints = false
        genreInfo.topAnchor.constraint(equalTo: movieTitle.bottomAnchor, constant: 5)
            .isActive = true
        genreInfo.leadingAnchor.constraint(equalTo: movieTitle.leadingAnchor)
            .isActive = true
        genreInfo.trailingAnchor.constraint(equalTo: movieTitle.trailingAnchor)
            .isActive = true
    }
    
    private func setupPlotView() {
        plot.textColor = .gray
        plot.backgroundColor = .clear
        plot.font = UIFont.systemFont(ofSize: 16)
        plot.numberOfLines = 4

        addSubview(plot)
        
        plot.translatesAutoresizingMaskIntoConstraints = false
        plot.topAnchor.constraint(equalTo: genreInfo.bottomAnchor, constant: 5)
            .isActive = true
        plot.leadingAnchor.constraint(equalTo: genreInfo.leadingAnchor)
            .isActive = true
        plot.trailingAnchor.constraint(equalTo: genreInfo.trailingAnchor)
            .isActive = true
    }
    
    private func setupRating1View() {
        rating1.textColor = .yellow
        rating1.font = UIFont.boldSystemFont(ofSize: 14)
        rating1.numberOfLines = 0
        rating1.adjustsFontSizeToFitWidth = true
        
        addSubview(rating1)
        
        rating1.translatesAutoresizingMaskIntoConstraints = false
        rating1.topAnchor.constraint(equalTo: plot.bottomAnchor, constant: 10)
            .isActive = true
        rating1.leadingAnchor.constraint(equalTo: plot.leadingAnchor)
            .isActive = true
        rating1.trailingAnchor.constraint(equalTo: plot.trailingAnchor)
            .isActive = true
    }

    private func setupRating2View() {
        rating2.textColor = .yellow
        rating2.font = UIFont.boldSystemFont(ofSize: 14)
        rating2.numberOfLines = 0
        rating2.adjustsFontSizeToFitWidth = true
        
        addSubview(rating2)
        
        rating2.translatesAutoresizingMaskIntoConstraints = false
        rating2.topAnchor.constraint(equalTo: rating1.bottomAnchor, constant: 5)
            .isActive = true
        rating2.leadingAnchor.constraint(equalTo: rating1.leadingAnchor)
            .isActive = true
        rating2.trailingAnchor.constraint(equalTo: rating1.trailingAnchor)
            .isActive = true
    }
    
}
