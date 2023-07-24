//
//  MoviesViewModelTests.swift
//  OmadaMoviesTests
//
//  Created by Jarod Luebbert on 7/23/23.
//

import XCTest
import Combine
@testable import OmadaMovies

final class MoviesViewModelTests: XCTestCase {
    
    private var disposables = Set<AnyCancellable>()

    func testMovieSearch() async throws {
        let viewModel = MoviesSearchViewModel()
        
        var firstSearchCount: Int = 0
        
        let firstSearch = expectation(description: "First search request")
        viewModel.$movies
            .filter { !$0.isEmpty }
            .first()
            .sink { movies in
                let theAvengers = movies.first(where: { $0.title == "The Avengers" })
                XCTAssertNotNil(theAvengers)
                firstSearch.fulfill()
                firstSearchCount = movies.count
                
                XCTAssert(firstSearchCount > 0)
                XCTAssert(viewModel.hasNextPage)
                viewModel.fetchNextPage()
            }
            .store(in: &disposables)
        
        let nextPage = expectation(description: "Next page")
        viewModel.$movies
            .filter { !$0.isEmpty }
            .dropFirst()
            .sink { movies in
                let theAvengers = movies.first(where: { $0.title == "The Avengers" })
                XCTAssertNotNil(theAvengers)
                XCTAssert(firstSearchCount > 0 && movies.count > firstSearchCount)
                nextPage.fulfill()
            }
            .store(in: &disposables)
        
        viewModel.searchTerm = "The Avengers"
        wait(for: [firstSearch, nextPage], timeout: 2.0)
    }
    
}
