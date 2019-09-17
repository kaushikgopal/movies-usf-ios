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

    func test_whenScreenLoaded_thenHelpfulHintsProvided() {
        let api: MovieSearchService = FakeMovieSearchService()
        let viewModel = MovieSearchVM(api)
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
        XCTAssertEqual(vs0.rating1, "IMDB :     X/10")
        XCTAssertEqual(vs0.rating2, "Rotten T :      XX%")
    }

    func skip_givenBladeMovieExists_whenSearchingForTheMovie_thenMovieDisplays() {}

}

final class FakeMovieSearchService: MovieSearchService {

    func searchMovie(name: String) -> Observable<MovieSearchResult?> {
        let jsonString =
        """
        {
            Actors = "Wesley Snipes, Stephen Dorff, Kris Kristofferson, N'Bushe Wright";
            Awards = "4 wins & 8 nominations.";
            BoxOffice = "N/A";
            Country = USA;
            DVD = "22 Dec 1998";
            Director = "Stephen Norrington";
            Genre = "Action, Horror, Sci-Fi";
            Language = "English, Russian, Serbian";
            Metascore = 45;
            Plot = "A half-vampire, half-mortal man becomes a protector of the mortal race, while slaying evil vampires.";
            Poster = "https://m.media-amazon.com/images/M/MV5BOTk2NDNjZWQtMGY0Mi00YTY2LWE5MzctMGRhZmNlYzljYTg5XkEyXkFqcGdeQXVyMTAyNjg4NjE0._V1_SX300.jpg";
            Production = "New Line Cinema";
            Rated = R;
            Ratings =     (
                        {
                    Source = "Internet Movie Database";
                    Value = "7.1/10";
                },
                        {
                    Source = "Rotten Tomatoes";
                    Value = "54%";
                },
                        {
                    Source = Metacritic;
                    Value = "45/100";
                }
            );
            Released = "21 Aug 1998";
            Response = True;
            Runtime = "120 min";
            Title = Blade;
            Type = movie;
            Website = "N/A";
            Writer = "David S. Goyer";
            Year = 1998;
            imdbID = tt0120611;
            imdbRating = "7.1";
            imdbVotes = "229,728";
        }
        """
        let decoder = JSONDecoder.init()
        let data = jsonString.data(using: .utf8)!

        guard let bladeMovieSearchResult: MovieSearchResult = try? decoder.decode(MovieSearchResult.self, from: data) else {
            return Observable.empty()
        }
        return Observable.just(bladeMovieSearchResult)
    }
}
