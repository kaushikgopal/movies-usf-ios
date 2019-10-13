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
import RxBlocking

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

    // given: movie result shown already
    // when : searching for new movie
    // then : nil-ify poster url appropriately
    //          don't nil-ify in searching state
    //          but do it after search is complete
    //          and search result is not the same as before
    func test_movieResultShown_searchingForNewMovie_nilifyPosterAppropriately() {
        // this might seem like a weird experience
        // but we're doing it to prevent multiple network req calls to image poster loading
        // especially if the image lands up being the same

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
        scheduler.scheduleAt(2) {
            viewModel.processViewEvent(event: MovieSearchVM.ViewEvent.searchMovie("Blades"))
        }
        scheduler.start()

        let vs1: [MovieSearchVM.ViewState] =
            vsObserver.events
                .filter { $0.time == 1 }
                .compactMap { $0.value.element }

        let vs2: [MovieSearchVM.ViewState] =
            vsObserver.events
                .filter { $0.time == 2 }
                .compactMap { $0.value.element }

        XCTAssertEqual(vs1.count, 2)
        XCTAssertEqual(vs2.count, 2)

        XCTAssertEqual(vs2.first!.genres, "searching...")
        XCTAssertNotNil(vs2.first!.moviePosterUrl)
        XCTAssertNil(vs2.last!.moviePosterUrl)
    }

    // given: movie result displayed
    // when : clicking the movie result
    // then : toggle it as a bookmarked movie
    func test_movieResultShown_clickingMovieResult_togglesBookmark() {
        // show the movie result
        let movieRepo = MovieRepositoryImpl(FakeMovieSearchService())
        let viewModel = MovieSearchVM(repo: movieRepo)

        let vsObserver = scheduler.createObserver(MovieSearchVM.ViewState.self)
        let veObserver = scheduler.createObserver(MovieSearchVM.ViewEffect.self)
        viewModel.viewState.subscribe(vsObserver).disposed(by: dbag)
        viewModel.viewEffects.subscribe(veObserver).disposed(by: dbag)

        scheduler.scheduleAt(0) {
            viewModel.processViewEvent(event: MovieSearchVM.ViewEvent.screenLoad)
            viewModel.processViewEvent(event: MovieSearchVM.ViewEvent.searchMovie("blade"))
        }
        scheduler.scheduleAt(1) {
            // click movie once to bookmark it
            viewModel.processViewEvent(event: MovieSearchVM.ViewEvent.toggleMovie("blade"))
        }
        scheduler.scheduleAt(2) {
            // click movie again to unbookmark
            viewModel.processViewEvent(event: MovieSearchVM.ViewEvent.toggleMovie("blade"))
        }

        scheduler.start()

        
        // 1: movie toggled once
        let ve1: [MovieSearchVM.ViewEffect] =
            veObserver.events
                .filter { $0.time == 1 }
                .compactMap { $0.value.element }

        XCTAssertEqual(vsObserver.events.filter { $0.time == 1 }.count, 0)
        XCTAssertEqual(ve1.count, 1)
        XCTAssertEqual(ve1.first!, MovieSearchVM.ViewEffect.addedBookmark("Bookmarked Blade"))
        XCTAssertEqual(try! movieRepo.movieBookmarksListOnce().toBlocking().toArray().count, 1)
        
        let ve2: [MovieSearchVM.ViewEffect] =
            veObserver.events
                .filter { $0.time == 2 }
                .compactMap { $0.value.element }

         XCTAssertEqual(vsObserver.events.filter { $0.time == 2 }.count, 0)
         XCTAssertEqual(ve2.count, 1)
         XCTAssertEqual(ve2.first!, MovieSearchVM.ViewEffect.removedBookmark("Removed from Bookmarks"))
         XCTAssertEqual(try! movieRepo.movieBookmarksListOnce().toBlocking().toArray().count, 0)
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
            return Observable.just(nil)
        }
    }
}
