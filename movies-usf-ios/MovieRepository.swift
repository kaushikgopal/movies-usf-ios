//
//  MovieRepository.swift
//  movies-usf-ios
//
//  Created by Kaushik Gopal on 9/20/19.
//  Copyright © 2019 Kaushik Gopal. All rights reserved.
//

import RxSwift

protocol MovieRepository {
    func movieOnce(title: String) -> Observable<MovieSearchResult?>
}

final class MovieRepositoryImpl: MovieRepository {

    init(_ service: MovieSearchService = MovieSearchServiceImpl()) {
        searchService = service
    }

    func movieOnce(title: String) -> Observable<MovieSearchResult?> {
        if let movie = fauxDb[title.lowercased()]  {
            return Observable.just(movie)
        }

        return searchService.searchMovie(name: title.lowercased())
            .do(onNext: { [unowned self] result in
                if result != nil {
                    self.fauxDb[title.lowercased()] = result
                }
            })
    }

    private let searchService: MovieSearchService
    private var fauxDb: [String: MovieSearchResult] = [:]
}