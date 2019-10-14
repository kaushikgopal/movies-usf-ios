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
    
    let posterImageView = UIImageView()
    let movieTitleView = UILabel()
    let genreInfoView = UILabel()
    let rating1View = UILabel()
    let rating2View = UILabel()
    let plotSummaryView = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
       backgroundColor = UIColor.black
        
        setupPosterView()
        setupTitleView()
        setupGenreInfoView()
        setupPlotView()
        setupRating1View()
        setupRating2View()
        
        posterImageView.load(imageUrl: "https://m.media-amazon.com/images/M/MV5BOTk2NDNjZWQtMGY0Mi00YTY2LWE5MzctMGRhZmNlYzljYTg5XkEyXkFqcGdeQXVyMTAyNjg4NjE0._V1_SX300.jpg")
        movieTitleView.text = "Dummy bookmark"
        genreInfoView.text = "Horror Comedy"
        rating1View.text = "imdb"
        rating2View.text = "rotten tomatoes"
        plotSummaryView.text = "some summary text goes here. lipsum blah blah "
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(
        posterUrl: String,
        title: String,
        genreInfo: String,
        plotSummary: String,
        rating1: String,
        rating2: String
    ) {
        posterImageView.load(imageUrl: posterUrl)
        movieTitleView.text = title
        genreInfoView.text = genreInfo
        plotSummaryView.text = plotSummary
        rating1View.text = rating1
        rating2View.text = rating2
    }
    
    private func setupPosterView() {
        posterImageView.layer.cornerRadius = 5
        posterImageView.clipsToBounds = true
        
        addSubview(posterImageView)

        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        posterImageView.heightAnchor.constraint(equalToConstant: CGFloat(BookmarkCell.HEIGHT - 20)).isActive = true
        posterImageView.widthAnchor.constraint(equalTo: posterImageView.heightAnchor, multiplier: 1/1.5).isActive = true
    }
    
    private func setupTitleView() {
        
        movieTitleView.textColor = .white
        movieTitleView.font = UIFont.boldSystemFont(ofSize: 22)
        movieTitleView.numberOfLines = 0
        movieTitleView.adjustsFontSizeToFitWidth = true
        
        addSubview(movieTitleView)

        movieTitleView.translatesAutoresizingMaskIntoConstraints = false
        movieTitleView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        movieTitleView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 20).isActive = true
        movieTitleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
    }
    
    private func setupGenreInfoView()  {
        genreInfoView.textColor = .green
        genreInfoView.font = UIFont.systemFont(ofSize: 16)
        genreInfoView.numberOfLines = 0
        genreInfoView.adjustsFontSizeToFitWidth = true

        addSubview(genreInfoView)
        
        genreInfoView.translatesAutoresizingMaskIntoConstraints = false
        genreInfoView.topAnchor.constraint(equalTo: movieTitleView.bottomAnchor, constant: 5)
            .isActive = true
        genreInfoView.leadingAnchor.constraint(equalTo: movieTitleView.leadingAnchor)
            .isActive = true
        genreInfoView.trailingAnchor.constraint(equalTo: movieTitleView.trailingAnchor)
            .isActive = true
    }
    
    private func setupPlotView() {
        plotSummaryView.textColor = .gray
        plotSummaryView.backgroundColor = .clear
        plotSummaryView.font = UIFont.systemFont(ofSize: 16)
        plotSummaryView.numberOfLines = 4

        addSubview(plotSummaryView)
        
        plotSummaryView.translatesAutoresizingMaskIntoConstraints = false
        plotSummaryView.topAnchor.constraint(equalTo: genreInfoView.bottomAnchor, constant: 5)
            .isActive = true
        plotSummaryView.leadingAnchor.constraint(equalTo: genreInfoView.leadingAnchor)
            .isActive = true
        plotSummaryView.trailingAnchor.constraint(equalTo: genreInfoView.trailingAnchor)
            .isActive = true
    }
    
    private func setupRating1View() {
        rating1View.textColor = .yellow
        rating1View.font = UIFont.boldSystemFont(ofSize: 14)
        rating1View.numberOfLines = 0
        rating1View.adjustsFontSizeToFitWidth = true
        
        addSubview(rating1View)
        
        rating1View.translatesAutoresizingMaskIntoConstraints = false
        rating1View.topAnchor.constraint(equalTo: plotSummaryView.bottomAnchor, constant: 10)
            .isActive = true
        rating1View.leadingAnchor.constraint(equalTo: plotSummaryView.leadingAnchor)
            .isActive = true
        rating1View.trailingAnchor.constraint(equalTo: plotSummaryView.trailingAnchor)
            .isActive = true
    }

    private func setupRating2View() {
        rating2View.textColor = .yellow
        rating2View.font = UIFont.boldSystemFont(ofSize: 14)
        rating2View.numberOfLines = 0
        rating2View.adjustsFontSizeToFitWidth = true
        
        addSubview(rating2View)
        
        rating2View.translatesAutoresizingMaskIntoConstraints = false
        rating2View.topAnchor.constraint(equalTo: rating1View.bottomAnchor, constant: 5)
            .isActive = true
        rating2View.leadingAnchor.constraint(equalTo: rating1View.leadingAnchor)
            .isActive = true
        rating2View.trailingAnchor.constraint(equalTo: rating1View.trailingAnchor)
            .isActive = true
    }
    
}
