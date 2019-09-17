//
//  File.swift
//  movies-usf-ios
//
//  Created by Kaushik Gopal on 9/16/19.
//  Copyright © 2019 Kaushik Gopal. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol MovieSearchService {
    func searchMovie(name: String) -> Observable<MovieSearchResult?>
}

final class MovieSearchServiceImpl: MovieSearchService {

    let session = URLSession.shared

    func searchMovie(name: String) -> Observable<MovieSearchResult?> {

        let url = URL(string: "http://www.omdbapi.com/?apikey=\(K.omdbApiKey)&t=\(name)")!
        let request = URLRequest(url: url)

        return URLSession.shared
            .rx
            .data(request: request)
            .map { data in
                let decoder = JSONDecoder()
                return try decoder.decode(MovieSearchResult.self, from: data)
            }
    }
}

struct MovieSearchResult: Codable {
    let Title: String
    let Genre: String
    let Plot: String
    let Poster: String
    let Ratings: [Rating]
}

struct Rating: Codable {
    let Source: String
    let Value: String
}
