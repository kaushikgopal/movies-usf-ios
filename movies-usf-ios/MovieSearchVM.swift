//
//  MovieSearchVM.swift
//  movies-usf-ios
//
//  Created by Kaushik Gopal on 9/15/19.
//  Copyright © 2019 Kaushik Gopal. All rights reserved.
//

import RxSwift

final class MovieSearchVM {

    enum ViewEvent {
        case screenLoad
        case searchMovie(String)
    }
    
    enum ViewResult {
        case screenLoadResult
        case searchMovieResult(
            movieTitle: String
        )
    }
    
    struct ViewState {
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
                moviePosterUrl: moviePosterUrl,
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
    
    init() {

        let results: Observable<ViewResult> = eventToResult(
            events: viewEventSubject
        )
        .do(onNext: { print("🛠 MovieSearchVM: result \($0)") })
        .share()
        
        viewState = results.resultToViewState()
            .do(onNext: { print("🛠 MovieSearchVM: view[state] \($0)") })
        viewEffects = results.resultToViewEffect()
            .do(onNext: { print("🛠 MovieSearchVM: view[effect] \($0)") })
    }

    // MARK: Public api
    
    let viewState: Observable<ViewState>
    let viewEffects: Observable<ViewEffect>

    func processViewEvent(event: ViewEvent) {
        viewEventSubject.onNext(event)
    }

    // MARK: Private properties
    private let viewEventSubject: PublishSubject<ViewEvent> = .init()
}

private func eventToResult(
    events: Observable<MovieSearchVM.ViewEvent>
) -> Observable<MovieSearchVM.ViewResult> {
    return events
        .do(onNext: { print("🛠 MovieSearchVM: event \($0)") })
        .flatMap { event -> Observable<MovieSearchVM.ViewResult> in
            switch event {
            case .screenLoad:
                return Observable.just(.screenLoadResult)
            case .searchMovie(let (movieSearched)):
                return Observable.just(.searchMovieResult(movieTitle: movieSearched))
        }
    }
}

private extension Observable where Element == MovieSearchVM.ViewResult {
    func resultToViewState() -> Observable<MovieSearchVM.ViewState> {
        let startingViewState = MovieSearchVM.ViewState(
            movieTitle: "Loading..",
            moviePosterUrl: "https://i.ytimg.com/vi/07So_lJQyqw/maxresdefault.jpg",
            genres: "",
            plot: "",
            rating1: "",
            rating2: ""
        )

        return self.scan(startingViewState) { previousViewState, result in
            switch result {
                case .screenLoadResult:
                    return previousViewState.copy(
                        movieTitle: "Movie Title (YYYY)",
                        moviePosterUrl: nil,
                        genres: "Genre (Action, Sci-Fi)",
                        plot: "If we have a short summary of the Movie's plot, it will show up here.",
                        rating1: "IMDB :   7.1/10",
                        rating2: "Rotten T :      81%"
                    )
            case .searchMovieResult(let movieTitle):
                return previousViewState.copy(
                    movieTitle: movieTitle + " todo",
                    moviePosterUrl: nil,
                    genres: "Genre (Action, Sci-Fi)",
                    plot: "If we have a short summary of the Movie's plot, it will show up here.",
                    rating1: "IMDB :   7.1/10",
                    rating2: "Rotten T :      81%"
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
}
