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
            events: viewEventSubject,
            repo: repo
        )
        .do(onNext: { print("🛠 BookmarksVM: result \($0)") })
        .share()
        
        viewState = resultToViewState(resultStream: r)
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
    return Observable<BookmarksVM.ViewResult>.empty()
}

private func resultToViewState(
    resultStream: Observable<BookmarksVM.ViewResult>
) -> Observable<BookmarksVM.ViewState> {
    return Observable<BookmarksVM.ViewState>.empty()
}

private func resultToViewEffects(
    resultStream: Observable<BookmarksVM.ViewResult>
) -> Observable<BookmarksVM.ViewEffect> {
    return Observable<BookmarksVM.ViewEffect>.empty()
}

extension BookmarksVM {
    enum ViewEvent {}

    struct ViewState: Equatable {}

    enum ViewEffect: Equatable {
        case noEffect
    }
}

private extension BookmarksVM {
    enum ViewResult {}
}
    
