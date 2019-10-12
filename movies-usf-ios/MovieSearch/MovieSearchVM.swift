//
//  MovieSearchVM.swift
//  movies-usf-ios
//
//  Created by Kaushik Gopal on 9/15/19.
//  Copyright © 2019 Kaushik Gopal. All rights reserved.
//

import RxSwift

final class MovieSearchVM {
    convenience init(_ api: MovieSearchService = MovieSearchServiceImpl()) {
        self.init(repo: MovieRepositoryImpl(api))
    }
    
    required init(repo: MovieRepository) {
        let results: Observable<ViewResult> = eventToResult(
            events: viewEventSubject,
            repo: repo
        )
        .do(onNext: { print("🛠 MovieSearchVM: result \($0)") })
        .share()
    
        viewEventSubject
            .scan(seedViewState) { oldViewState, event in
                oldViewState
            }
        
        viewState = results.resultToViewState()
            .do(onNext: { print("🛠 MovieSearchVM: view[state] \($0)") })
            .distinctUntilChanged()
        viewEffects = results.resultToViewEffect()
            .do(onNext: { print("🛠 MovieSearchVM: view[effect] \($0)") })
    }

    let viewState: Observable<ViewState>
    let viewEffects: Observable<ViewEffect>

    private let viewEventSubject: PublishSubject<ViewEvent> = .init()
    private let seedViewState = MovieSearchVM.ViewState(
        movieTitle: "Loading...",
        moviePosterUrl: nil,
        genres: "Genre (Action, Sci-Fi)",
        plot: "If we have a short summary of the Movie's plot, it will show up here.",
        rating1: "IMDB :   7.1/10",
        rating2: "Rotten T :      81%"
    )
    
    
    func processViewEvent(event: ViewEvent) {
        viewEventSubject.onNext(event)
    }
    
}

private func eventToResult(
    events: Observable<MovieSearchVM.ViewEvent>,
    repo: MovieRepository
) -> Observable<MovieSearchVM.ViewResult> {
    return events
        .do(onNext: { print("🛠 MovieSearchVM: event \($0)") })
        .flatMap { event -> Observable<MovieSearchVM.ViewResult> in
            switch event {
            case .screenLoad:
                return Observable.just(.screenLoadResult)
            case .searchMovie(let (movieSearched)):
                let loadingResult: MovieSearchVM.ViewResult =
                    .searchMovieResult(
                        movieSearchText: movieSearched, movieResult: nil, loading: true, error: nil
                    )
                return repo.movieOnce(title: movieSearched)
                    .map {
                        if let movie = $0 {
                            return MovieSearchVM.ViewResult.searchMovieResult(
                                movieSearchText: movieSearched, movieResult: movie, loading: false, error: nil
                            )
                        }
                        return MovieSearchVM.ViewResult.searchMovieResult(
                            movieSearchText: movieSearched, movieResult: nil, loading: false, error: nil
                        )
                    }
                    .catchError { err in
                        let result = MovieSearchVM.ViewResult.searchMovieResult(
                            movieSearchText: movieSearched, movieResult: nil, loading: false, error: err
                        )
                        return Observable.just(result)
                    }
                    .startWith(loadingResult)
        }
    }
}

private extension Observable where Element == MovieSearchVM.ViewResult {
    func resultToViewState() -> Observable<MovieSearchVM.ViewState> {
        let startingViewState = MovieSearchVM.ViewState(
            movieTitle: "Loading...",
            moviePosterUrl: nil,
            genres: "Genre (Action, Sci-Fi)",
            plot: "If we have a short summary of the Movie's plot, it will show up here.",
            rating1: "IMDB :   7.1/10",
            rating2: "Rotten T :      81%"
        )

        return self.scan(startingViewState) { previousViewState, result in
            switch result {
                case .screenLoadResult:
                    let (r1, r2) = self.formattedRatings(nil, useTemplate: true)
                    return previousViewState.copy(
                        movieTitle: "Movie Title (YYYY)",
                        moviePosterUrl: nil,
                        genres: "Genre (Action, Sci-Fi)",
                        plot: "If we have a short summary of the Movie's plot, it will show up here.",
                        rating1: r1,
                        rating2: r2
                    )
            case .searchMovieResult(let result):

                if result.loading {
                    return previousViewState.copy(
                        movieTitle: "\(result.movieSearchText)",
                        genres: "searching...",
                        plot: "",
                        rating1: "",
                        rating2: ""
                    )
                }

                if let err = result.error {
                    return MovieSearchVM.ViewState(
                        movieTitle: "\(result.movieSearchText)",
                        moviePosterUrl: nil,
                        genres: "error...☹️",
                        plot: err.localizedDescription,
                        rating1: "",
                        rating2: ""
                    )
                }

                if let movie = result.movieResult {

                    if !movie.searchSuccess {
                        return previousViewState.copy(
                            moviePosterUrl: nil,
                            genres: "not found...☹️",
                            plot: movie.searchErrorMessage,
                            rating1: "",
                            rating2: ""
                        )
                    }

                    let (imdbRating, rtRating): (String, String) =
                        self.formattedRatings(movie.ratings)

                    return MovieSearchVM.ViewState(
                        movieTitle: movie.title,
                        moviePosterUrl: movie.posterUrl,
                        genres: movie.genre,
                        plot: movie.plot,
                        rating1: imdbRating,
                        rating2: rtRating
                    )
                }

                return MovieSearchVM.ViewState(
                    movieTitle: "\(result.movieSearchText)",
                    moviePosterUrl: nil,
                    genres: "not found...☹️",
                    plot: "",
                    rating1: "",
                    rating2: ""
                )
            }
        }
    }
    
    func resultToViewEffect() -> Observable<MovieSearchVM.ViewEffect> {
        return self.map { (result: MovieSearchVM.ViewResult) in
            switch result {
            case .screenLoadResult, .searchMovieResult(_):
                return .noEffect
            }
        }
    }
    
    private func formattedRatings(
        _ ratings: [Rating]?,
        useTemplate: Bool = false
    ) -> (String, String) {
        var rs: [Rating]? = ratings
        
        if rs == nil {
            if useTemplate {
                rs = [
                    Rating(Source: "Internet Movie Database", Value: "X/10"),
                    Rating(Source: "Rotten Tomatoes", Value: "X %")
                ]
            } else {
                return ("", "")
            }
        }
        
        let imdbRating: String = rs!
            .first(where: { $0.Source == "Internet Movie Database" })
            .map { rating in
                let ratingPrefix = "IMDB :"
                let ratingSuffix = " \(rating.Value)"
                
                return ratingPrefix.padding(
                    toLength: 20 - ratingSuffix.count,
                    withPad: " ",
                    startingAt: 0
                ) + " \(ratingSuffix)"
            } ?? ""
        
        let rtRating: String = rs!
            .first(where: { $0.Source == "Rotten Tomatoes" })
            .map { rating in
                let ratingPrefix = "Rotten T:"
                let ratingSuffix = " \(rating.Value)"
                
                return ratingPrefix.padding(
                    toLength: 20 - ratingSuffix.count,
                    withPad: " ",
                    startingAt: 0
                    ) + " \(ratingSuffix)"
            } ?? ""
        
        return (imdbRating, rtRating)
    }
}

extension MovieSearchVM {
    enum ViewEvent {
        case screenLoad
        case searchMovie(String)
    }
}

private extension MovieSearchVM {
    enum ViewResult {
        case screenLoadResult
        case searchMovieResult(
            movieSearchText: String,
            movieResult: MovieSearchResult?,
            loading: Bool,
            error: Error?
        )
    }
}

extension MovieSearchVM {
    struct ViewState: Equatable {
        let movieTitle: String
        let moviePosterUrl: String?
        let genres: String
        let plot: String
        let rating1: String
        let rating2: String

        // helpful function to prevent mutating existing state
        func copy(
            movieTitle: String? = nil,
            moviePosterUrl: String? = nil,
            genres: String? = nil,
            plot: String? = nil,
            rating1: String? = nil,
            rating2: String? = nil
        ) -> ViewState {
            return ViewState(
                movieTitle: movieTitle ?? self.movieTitle,
                moviePosterUrl: moviePosterUrl ?? self.moviePosterUrl,
                genres: genres ?? self.genres,
                plot: plot ?? self.plot,
                rating1: rating1 ?? self.rating1,
                rating2: rating2 ?? self.rating2
            )
        }
    }

    enum ViewEffect {
        case noEffect
    }
}
