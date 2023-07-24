//
//  MockDataMovies.swift
//  OmadaMovies
//
//  Created by Jarod Luebbert on 7/23/23.
//

import Foundation

class MockDataMovies {
    static let shared = MockDataMovies()
    
    private init() {}
    
    var movies: [Movie] {
        Array(repeating: movie, count: 100)
    }
    
    var movie: Movie {
        Movie(id: 4538,
              title: "The Darjeeling Limited",
              originalTitle: "The Darjeeling Limited",
              overview: "Three American brothers who have not spoken to each other in a year set off on a train voyage across India with a plan to find themselves and bond with each other -- to become brothers again like they used to be. Their \"spiritual quest\", however, veers rapidly off-course (due to events involving over-the-counter pain killers, Indian cough syrup, and pepper spray).",
              popularity: 14.723,
              posterPath: "/oSW5OVXTulaIXcoNwJAp5YEKpbP.jpg",
              releaseDate: "2007-09-07",
              voteAverage: 7.164,
              voteCount: 3175)
    }
}
