//
//  BookmarkCell.swift
//  movies-usf-ios
//
//  Created by Kaushik Gopal on 10/13/19.
//  Copyright © 2019 Kaushik Gopal. All rights reserved.
//

import UIKit

class BookmarkCell: UITableViewCell {

    static let HEIGHT = CGFloat(200.0)
    static let IDENTIFIER = "BookmarksVC::BookmarkCell"
    
    let posterImageView = UIImageView()
    let movieTitleView = UILabel()
    let genreInfoView = UILabel()
    let rating1View = UILabel()
    let rating2View = UILabel()
    let plotSummaryView = UITextView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.black
        
        setupPosterView()
        setupTitleView()
        setupGenreInfoView()
        setupRating2View()
        setupRating1View()
        setupPlotView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(
        posterUrl: String?,
        title: String,
        genreInfo: String,
        plotSummary: String,
        rating1: String? = nil,
        rating2: String? = nil
    ) {
        posterImageView.load(imageUrl: posterUrl)
        movieTitleView.text = title
        genreInfoView.text = genreInfo
        plotSummaryView.text = plotSummary
        rating1View.text = rating1
        rating2View.text = rating2
    }
    
    func bind(clickListener imageTap: UITapGestureRecognizer) {
        posterImageView.addGestureRecognizer(imageTap)
        posterImageView.isUserInteractionEnabled = true
    }
    
    private func setupPosterView() {
        posterImageView.backgroundColor = .darkGray
        posterImageView.layer.cornerRadius = 5
        posterImageView.clipsToBounds = true
        
        addSubview(posterImageView)

        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        posterImageView.heightAnchor.constraint(equalToConstant: BookmarkCell.HEIGHT - 20).isActive = true
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
        genreInfoView.trailingAnchor.constraint(equalTo: movieTitleView.trailingAnchor, constant: -5)
            .isActive = true
    }

    private func setupRating2View() {
        rating2View.textColor = .yellow
        rating2View.font = UIFont.boldSystemFont(ofSize: 14)
        rating2View.numberOfLines = 0
        rating2View.adjustsFontSizeToFitWidth = true
        
        addSubview(rating2View)
        
        rating2View.translatesAutoresizingMaskIntoConstraints = false
        rating2View.bottomAnchor.constraint(equalTo: posterImageView.bottomAnchor)
            .isActive = true
        rating2View.leadingAnchor.constraint(equalTo: movieTitleView.leadingAnchor)
            .isActive = true
        rating2View.trailingAnchor.constraint(equalTo: movieTitleView.trailingAnchor)
            .isActive = true
    }

    private func setupRating1View() {
        rating1View.textColor = .yellow
        rating1View.font = UIFont.boldSystemFont(ofSize: 14)
        rating1View.numberOfLines = 0
        rating1View.adjustsFontSizeToFitWidth = true
        
        addSubview(rating1View)
        
        rating1View.translatesAutoresizingMaskIntoConstraints = false
        rating1View.bottomAnchor.constraint(equalTo: rating2View.topAnchor, constant: -5)
            .isActive = true
        rating1View.leadingAnchor.constraint(equalTo: movieTitleView.leadingAnchor)
            .isActive = true
        rating1View.trailingAnchor.constraint(equalTo: movieTitleView.trailingAnchor)
            .isActive = true
    }

    private func setupPlotView() {
        plotSummaryView.textColor = .gray
        plotSummaryView.backgroundColor = .clear
        plotSummaryView.font = UIFont.systemFont(ofSize: 14)
        plotSummaryView.isEditable = false

        addSubview(plotSummaryView)
        
        plotSummaryView.translatesAutoresizingMaskIntoConstraints = false
        plotSummaryView.topAnchor.constraint(equalTo: genreInfoView.bottomAnchor, constant: 5)
            .isActive = true
        plotSummaryView.bottomAnchor.constraint(equalTo: rating1View.topAnchor, constant: -5)
            .isActive = true
        plotSummaryView.leadingAnchor.constraint(equalTo: movieTitleView.leadingAnchor, constant: -5)
            .isActive = true
        plotSummaryView.trailingAnchor.constraint(equalTo: movieTitleView.trailingAnchor, constant: -5)
        .isActive = true
    }
}
