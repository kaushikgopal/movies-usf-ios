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
import RxAlamofire

protocol MovieSearchService {
    func searchMovie(name: String) -> Observable<MovieSearchResult?>
}

final class MovieSearchServiceImpl: MovieSearchService {

    let session = URLSession.shared

    func searchMovie(name: String) -> Observable<MovieSearchResult?> {

        let params: [String: Any] = [
            "t": name,
            "apikey": K.omdbApiKey
        ]

        let url = URL(string: "http://www.omdbapi.com/")!
        return RxAlamofire.requestJSON(.get, url, parameters: params)
            .map { (_, data) in
                print("debugging \(data)")
                return nil
//                return try JSONDecoder().decode(MovieSearchResult.self, from: data)
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
