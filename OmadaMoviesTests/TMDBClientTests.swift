//
//  TMDBClientTests.swift
//  OmadaMoviesTests
//
//  Created by Jarod Luebbert on 7/23/23.
//

import XCTest
@testable import OmadaMovies

final class TMDBClientTests: XCTestCase {

    func testMovieSearchRequest() async throws {
        let client = TMDBClient()
        let movies = try await client.movies(for: "The Avengers")
        let theAvengers = movies.results.first(where: { $0.title == "The Avengers" })
        XCTAssertNotNil(theAvengers)
        XCTAssert(movies.results.count > 0)
    }

}
