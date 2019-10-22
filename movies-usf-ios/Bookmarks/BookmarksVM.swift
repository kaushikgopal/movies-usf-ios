//
//  MovieSearchVM.swift
//  movies-usf-ios
//
//  Created by Kaushik Gopal on 10/15/19.
//  Copyright © 2019 Kaushik Gopal. All rights reserved.
//


import RxSwift

final class BookmarksVM {

    private let viewEventSubject: PublishSubject<ViewEvent> = .init()

    let viewState: Observable<ViewState>
    let viewEffects: Observable<ViewEffect>

    required init(repo: MovieRepository) {
        let r: Observable<ViewResult> = eventToResult(
            events: viewEventSubject.do(onNext: { print("🛠 BookmarksVM: event \($0)") }),
            repo: repo
        )
        .do(onNext: { print("🛠 BookmarksVM: result \($0)") })
        .share()
        
        viewState = resultToViewState(resultStream: r, repo: repo)
            .distinctUntilChanged()
            .do(onNext: { print("🛠 BookmarksVM: view[state] \($0)") })
        viewEffects = resultToViewEffects(resultStream: r)
            .filter { $0 != .noEffect }
            .do(onNext: { print("🛠 BookmarksVM: view[effect] \($0)") })
    }
    
    func processViewEvent(event e: BookmarksVM.ViewEvent) {
        viewEventSubject.onNext(e)
    }
}

private func eventToResult(
    events: Observable<BookmarksVM.ViewEvent>,
    repo: MovieRepository
) -> Observable<BookmarksVM.ViewResult> {
    return events.flatMap { event -> Observable<BookmarksVM.ViewResult> in
        switch (event) {
        case .viewResume:
            return Observable.just(.viewResumeResult)
        }
    }
}

private func resultToViewState(
    resultStream: Observable<BookmarksVM.ViewResult>,
    repo: MovieRepository
) -> Observable<BookmarksVM.ViewState> {
    return resultStream.flatMap { r -> Observable<BookmarksVM.ViewState> in
        switch(r) {
        case .viewResumeResult:
            return repo.bookmarkListOnce()
                .map { BookmarksVM.ViewState(bookmarks: $0) }
        }
    }
}

private func resultToViewEffects(
    resultStream: Observable<BookmarksVM.ViewResult>
) -> Observable<BookmarksVM.ViewEffect> {
    return Observable<BookmarksVM.ViewEffect>.empty()
}

extension BookmarksVM {
    enum ViewEvent {
        case viewResume
    }

    struct ViewState: Equatable {
        let bookmarks: [MovieSearchResult]
    }

    enum ViewEffect: Equatable {
        case noEffect
    }
}

private extension BookmarksVM {
    enum ViewResult {
        case viewResumeResult
    }
}
    
