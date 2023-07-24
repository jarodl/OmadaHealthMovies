//
//  MovieTests.swift
//  OmadaMoviesTests
//
//  Created by Jarod Luebbert on 7/23/23.
//

import XCTest
@testable import OmadaMovies

final class MovieTests: XCTestCase {

    func testFormatsReleaseDate() throws {
        let movie = Movie(id: 1,
                          title: "My Movie",
                          originalTitle: "My Movie",
                          overview: "",
                          popularity: 1.0,
                          posterPath: "/oSW5OVXTulaIXcoNwJAp5YEKpbP.jpg",
                          releaseDate: "2023-07-23",
                          voteAverage: 10.0,
                          voteCount: 1)
        XCTAssertEqual("July 23, 2023", movie.releaseDateFormatted)
        let invalidMovie = Movie(id: 2,
                          title: "My Movie",
                          originalTitle: "My Movie",
                          overview: "",
                          popularity: 1.0,
                          posterPath: "/oSW5OVXTulaIXcoNwJAp5YEKpbP.jpg",
                          releaseDate: "12345678",
                          voteAverage: 10.0,
                          voteCount: 1)
        XCTAssertEqual("Unknown", invalidMovie.releaseDateFormatted)
    }
    
    func testFormatsReleaseDateYear() throws {
        let movie = Movie(id: 1,
                          title: "My Movie",
                          originalTitle: "My Movie",
                          overview: "",
                          popularity: 1.0,
                          posterPath: "/oSW5OVXTulaIXcoNwJAp5YEKpbP.jpg",
                          releaseDate: "2023-07-23",
                          voteAverage: 10.0,
                          voteCount: 1)
        XCTAssertEqual("2023", movie.releaseDateYear)
        let invalidMovie = Movie(id: 2,
                          title: "My Movie",
                          originalTitle: "My Movie",
                          overview: "",
                          popularity: 1.0,
                          posterPath: "/oSW5OVXTulaIXcoNwJAp5YEKpbP.jpg",
                          releaseDate: "12345678",
                          voteAverage: 10.0,
                          voteCount: 1)
        XCTAssertEqual("Unknown", invalidMovie.releaseDateYear)

    }

}
