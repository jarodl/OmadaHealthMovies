//
//  Movie.swift
//  OmadaMovies
//
//  Created by Jarod Luebbert on 7/23/23.
//

import Foundation

extension Double {
    func rounded(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

struct Movie: Identifiable, Decodable, Equatable {
    let id: Int
    let title: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate: String
    let voteAverage: Double
    let voteCount: Int
    
    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/original\(posterPath)")
    }
    
    var releaseDateFormatted: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: releaseDate) else {
            return "Unknown"
        }
        
        dateFormatter.dateStyle = .long
        return dateFormatter.string(from: date)        
    }
    
    var ratingString: String {
        "\(voteAverage.rounded(to: 1)) / 10"
    }
    
    var releaseDateYear: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: releaseDate),
              let year = Calendar.current.dateComponents([.year], from: date).year else {
            return "Unknown"
        }
        
        return "\(year)"
    }
}
