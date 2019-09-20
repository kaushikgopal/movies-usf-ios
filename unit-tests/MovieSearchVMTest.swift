//
//  MovieSearchVMTest.swift
//  MovieSearchVMTest.swift
//
//  Created by Kaushik Gopal on 9/17/19.
//  Copyright © 2019 Kaushik Gopal. All rights reserved.
//

@testable import movies_usf_ios

import XCTest
import RxSwift
import RxTest

class MovieSearchVMTest: XCTestCase {

    var dbag: DisposeBag!
    var scheduler: TestScheduler!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        scheduler = TestScheduler(initialClock: 0)
        dbag = DisposeBag()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // when : screen loads
    // then : show helpful hints
    func test_screenLoads_showHelpfulHints() {
        let viewModel = MovieSearchVM(FakeMovieSearchService())
        let vsObserver = scheduler.createObserver(MovieSearchVM.ViewState.self)
        viewModel.viewState
            .subscribe(vsObserver)
            .disposed(by: dbag)

        scheduler.scheduleAt(0) {
            viewModel.processViewEvent(event: MovieSearchVM.ViewEvent.screenLoad)
        }
        scheduler.start()


        let vs0: MovieSearchVM.ViewState =
            vsObserver.events
                .filter { $0.time == 0 }
                .compactMap { $0.value.element }
                .last!

        XCTAssertEqual(vs0.movieTitle, "Movie Title (YYYY)")
        XCTAssertEqual(vs0.genres, "Genre (Action, Sci-Fi)")
        XCTAssertEqual(vs0.plot, "If we have a short summary of the Movie's plot, it will show up here.")
        XCTAssertEqual(vs0.rating1, "IMDB :           X/10")
        XCTAssertEqual(vs0.rating2, "Rotten T:         X %")
    }

    // given: movie "Blade" exists
    // when : searching for movie "Blade"
    // then : show result
    func test_movieBladeExists_searchingForIt_showMovieResult() {
        let viewModel = MovieSearchVM(FakeMovieSearchService())
        let vsObserver = scheduler.createObserver(MovieSearchVM.ViewState.self)
        viewModel.viewState
            .subscribe(vsObserver)
            .disposed(by: dbag)

        scheduler.scheduleAt(0) {
            viewModel.processViewEvent(event: MovieSearchVM.ViewEvent.screenLoad)
        }
        scheduler.scheduleAt(1) {
            viewModel.processViewEvent(event: MovieSearchVM.ViewEvent.searchMovie("Blade"))
        }
        scheduler.start()


        let vs1: MovieSearchVM.ViewState =
            vsObserver.events
                .filter { $0.time == 1 }
                .compactMap { $0.value.element }
                .last!

        XCTAssertEqual(vs1.movieTitle, "Blade")
        XCTAssertEqual(vs1.genres, "Action, Horror, Sci-Fi")
        XCTAssertEqual(
            vs1.moviePosterUrl,
            "https://m.media-amazon.com/images/M/MV5BOTk2NDNjZWQtMGY0Mi00YTY2LWE5MzctMGRhZmNlYzljYTg5XkEyXkFqcGdeQXVyMTAyNjg4NjE0._V1_SX300.jpg"
        )
        XCTAssertEqual(vs1.plot, "A half-vampire, half-mortal man becomes a protector of the mortal race, while slaying evil vampires.")
        XCTAssertEqual(vs1.rating1, "IMDB :         7.1/10")
        XCTAssertEqual(vs1.rating2, "Rotten T:         54%")
    }

    // given: movie "Blade" exists
    // when : searching for it in lower case
    // then : show result
    func test_movieBladeExists_searchingForItInLowerCase_showMovieResult() {
        let viewModel = MovieSearchVM(FakeMovieSearchService())
        let vsObserver = scheduler.createObserver(MovieSearchVM.ViewState.self)
        viewModel.viewState
            .subscribe(vsObserver)
            .disposed(by: dbag)

        scheduler.scheduleAt(0) {
            viewModel.processViewEvent(event: MovieSearchVM.ViewEvent.screenLoad)
        }
        scheduler.scheduleAt(1) {
            viewModel.processViewEvent(event: MovieSearchVM.ViewEvent.searchMovie("blade"))
        }
        scheduler.start()


        let vs1: MovieSearchVM.ViewState =
            vsObserver.events
                .filter { $0.time == 1 }
                .compactMap { $0.value.element }
                .last!

        XCTAssertEqual(vs1.movieTitle, "Blade")
        XCTAssertEqual(vs1.genres, "Action, Horror, Sci-Fi")
        XCTAssertEqual(
            vs1.moviePosterUrl,
            "https://m.media-amazon.com/images/M/MV5BOTk2NDNjZWQtMGY0Mi00YTY2LWE5MzctMGRhZmNlYzljYTg5XkEyXkFqcGdeQXVyMTAyNjg4NjE0._V1_SX300.jpg"
        )
        XCTAssertEqual(vs1.plot, "A half-vampire, half-mortal man becomes a protector of the mortal race, while slaying evil vampires.")
        XCTAssertEqual(vs1.rating1, "IMDB :         7.1/10")
        XCTAssertEqual(vs1.rating2, "Rotten T:         54%")
    }

    // given: movie Blade Runner 2099 does not exist
    // when : searching for it
    // then : show movie not found error
    func test_movieDoesNotExist_searchingForIt_showMovieNotFoundError() {
        let viewModel = MovieSearchVM(FakeMovieSearchService())
        let vsObserver = scheduler.createObserver(MovieSearchVM.ViewState.self)
        viewModel.viewState
            .subscribe(vsObserver)
            .disposed(by: dbag)

        scheduler.scheduleAt(0) {
            viewModel.processViewEvent(event: MovieSearchVM.ViewEvent.screenLoad)
        }
        scheduler.scheduleAt(1) {
            viewModel.processViewEvent(event: MovieSearchVM.ViewEvent.searchMovie("Blade Runner 2099"))
        }
        scheduler.start()


        let vs1: MovieSearchVM.ViewState =
            vsObserver.events
                .filter { $0.time == 1 }
                .compactMap { $0.value.element }
                .last!

        XCTAssertEqual(vs1.movieTitle, "Blade Runner 2099")
        XCTAssertEqual(vs1.genres, "not found...☹️")
        XCTAssertEqual(vs1.moviePosterUrl, nil)
        XCTAssertEqual(vs1.plot, "Movie not found!")
        XCTAssertEqual(vs1.rating1, "")
        XCTAssertEqual(vs1.rating2, "")
    }
}

final class FakeMovieSearchService: MovieSearchService {

    func searchMovie(name: String) -> Observable<MovieSearchResult?> {

        switch name {
        case "blade runner 2099":
            let jsonString =
            """
            {"Error":"Movie not found!","Response":"False"}
            """
            let data = jsonString.filter { !$0.isNewline }.data(using: .utf8)!
            guard let bladeMovieSearchResult: MovieSearchResult =
                try? JSONDecoder().decode(MovieSearchResult.self, from: data) else {
                    return Observable.empty()
            }
            return Observable.just(bladeMovieSearchResult)
        case "blade":
            let jsonString =
            """
            {"Title":"Blade","Year":"1998","Rated":"R","Released":"21 Aug 1998","Runtime":"120 min","Genre":"Action, Horror, Sci-Fi","Director":"Stephen Norrington","Writer":"David S. Goyer","Actors":"Wesley Snipes, Stephen Dorff, Kris Kristofferson, N'Bushe Wright","Plot":"A half-vampire, half-mortal man becomes a protector of the mortal race, while slaying evil vampires.","Language":"English, Russian, Serbian","Country":"USA","Awards":"4 wins & 8 nominations.","Poster":"https://m.media-amazon.com/images/M/MV5BOTk2NDNjZWQtMGY0Mi00YTY2LWE5MzctMGRhZmNlYzljYTg5XkEyXkFqcGdeQXVyMTAyNjg4NjE0._V1_SX300.jpg","Ratings":[{"Source":"Internet Movie Database","Value":"7.1/10"},{"Source":"Rotten Tomatoes","Value":"54%"},{"Source":"Metacritic","Value":"45/100"}],"Metascore":"45","imdbRating":"7.1","imdbVotes":"229,728","imdbID":"tt0120611","Type":"movie","DVD":"22 Dec 1998","BoxOffice":"N/A","Production":"New Line Cinema","Website":"N/A","Response":"True"}
            """
            let data = jsonString.filter { !$0.isNewline }.data(using: .utf8)!
            guard let bladeMovieSearchResult: MovieSearchResult =
                try? JSONDecoder().decode(MovieSearchResult.self, from: data) else {
                    return Observable.empty()
                }
            return Observable.just(bladeMovieSearchResult)

        default:
            return Observable.empty()
        }
    }
}

final class FakeMovieSearchServiceNotFound: MovieSearchService {
    func searchMovie(name: String) -> Observable<MovieSearchResult?> {
        return Observable.just(nil)
    }
}
