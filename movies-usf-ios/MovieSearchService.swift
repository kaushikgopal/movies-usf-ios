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
        return RxAlamofire.requestString(.get, url, parameters: params)
            .map { (_, jsonString) in
                print("debugging \(jsonString)")
                let data = jsonString.filter { !$0.isNewline }.data(using: .utf8)!
                return try JSONDecoder().decode(MovieSearchResult.self, from: data)
            }
    }
}

struct MovieSearchResult: Codable {
    let searchSuccess: Bool
    let searchErrorMessage: String

    let title: String
    let genre: String
    let plot: String
    let posterUrl: String
    let ratings: [Rating]?

    // MARK: Decodable

    private enum CodingKeys: String, CodingKey {
        case searchSuccess = "Response"
        case searchErrorMessage = "Error"
        case title = "Title"
        case genre = "Genre"
        case plot = "Plot"
        case posterUrl = "Poster"
        case ratings = "Ratings"
    }

    // MARK: Decoder (custom)

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let searchSuccessString: String = try container.decodeIfPresent(String.self, forKey: .searchSuccess) {
            searchSuccess = searchSuccessString.lowercased() == "true" ? true : false
        } else {
            searchSuccess = false
        }

        searchErrorMessage = try container.decodeIfPresent(String.self, forKey: .searchErrorMessage) ?? ""
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        genre = try container.decodeIfPresent(String.self, forKey: .genre) ?? ""
        plot = try container.decodeIfPresent(String.self, forKey: .plot) ?? ""
        posterUrl = try container.decodeIfPresent(String.self, forKey: .posterUrl) ?? ""
        ratings = try container.decodeIfPresent([Rating].self, forKey: .ratings)
    }
}

struct Rating: Codable {
    let Source: String
    let Value: String
}
