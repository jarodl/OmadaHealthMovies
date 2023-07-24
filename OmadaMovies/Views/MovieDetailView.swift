//
//  MovieDetailView.swift
//  OmadaMovies
//
//  Created by Jarod Luebbert on 7/23/23.
//

import Foundation
import SwiftUI

struct MovieDetailRatingRow: View {
    let movie: Movie

    var body: some View {
        HStack {
            MovieImageView(movie: movie)
            VStack(alignment: .leading, spacing: 3.0) {
                Text(movie.title)
                    .font(.headline)
                Text(movie.releaseDateFormatted)
                    .font(.subheadline)
                    .padding([.bottom], 5.0)
                    .foregroundColor(.secondary)
                Text("Viewer Rating")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(movie.ratingString)
                    .fontWeight(.bold)
                    .padding([.bottom], 2.0)
                ProgressView(value: movie.voteAverage, total: 10.0)
            }
        }
    }
}

struct MovieOverviewRow: View {
    let movie: Movie
    var body: some View {
        Text("OVERVIEW")
            .fontWeight(.bold)
            .foregroundColor(.primary.opacity(0.6))
        Text(movie.overview)
            .font(.body)
    }
}

struct MovieDetailView: View {
    let movie: Movie
    
    var body: some View {
        List {
            MovieDetailRatingRow(movie: movie)
                .alignmentGuide(.listRowSeparatorLeading) { _ in
                    return 0
                }
            MovieOverviewRow(movie: movie)
        }
        .listStyle(.plain)
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(movie: MockDataMovies.shared.movie)
    }
}
