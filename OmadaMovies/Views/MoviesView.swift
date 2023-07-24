//
//  ContentView.swift
//  OmadaMovies
//
//  Created by Jarod Luebbert on 7/23/23.
//

import SwiftUI
import AlertToast

struct MoviesView: View {
    @StateObject private var viewModel = MoviesSearchViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.loading {
                    ProgressView()
                } else if viewModel.noMoviesFound {
                    Text("No Results")
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                } else {
                    MoviesListView(viewModel: viewModel)
                        .scrollDismissesKeyboard(.immediately)
                }
            }
            .navigationTitle("Movie Search")
        }
        .searchable(text: $viewModel.searchTerm)
        .toast(isPresenting: .constant(viewModel.searchError != nil), duration: 2.0, tapToDismiss: true) {
            AlertToast(type: .error(.red),
                       title: "Error",
                       subTitle: viewModel.searchError?.localizedDescription)
        }
    }
}

struct MoviesView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesView()
    }
}

struct MovieImageView: View {
    let movie: Movie
    let maxHeight: CGFloat
    let maxWidth: CGFloat
    
    init(movie: Movie, maxHeight: CGFloat = 100.0, maxWidth: CGFloat = 70.0) {
        self.movie = movie
        self.maxHeight = maxHeight
        self.maxWidth = maxWidth
    }
    
    var body: some View {
        if let posterURL = movie.posterURL {
            AsyncImage(url: posterURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(maxWidth: maxWidth, maxHeight: maxHeight)
                        .background(Color(white: 0.9))
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: maxWidth)
                case .failure:
                    VStack {
                        Image(systemName: "questionmark.app.dashed")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20.0, height: 20.0)
                    }
                    .frame(maxWidth: maxWidth, maxHeight: maxHeight)
                    .background(Color(white: 0.9))
                @unknown default:
                    EmptyView()
                        .frame(width: maxWidth, height: maxHeight)
                }
            }
        } else {
            VStack {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20.0, height: 20.0)
            }
            .frame(maxWidth: maxWidth, maxHeight: maxHeight)
            .background(Color(white: 0.9))
        }
    }
}

struct MovieRowView: View {
    let movie: Movie
    
    var body: some View {
        HStack {
            MovieImageView(movie: movie)
            
            VStack(alignment: .leading) {
                Text(movie.title)
                    .fontWeight(.bold)
                    .padding([.bottom], 1.0)
                Text(movie.releaseDateYear)
                    .fontWeight(.regular)
                    .foregroundColor(.secondary)
                Spacer()
            }
            .padding([.leading], 5.0)
            
            Spacer()
        }
        .frame(height: 100.0)
    }
}

struct MoviesListView: View {
    
    @ObservedObject var viewModel: MoviesSearchViewModel
    
    @Environment(\.isSearching) private var isSearching
    
    var body: some View {
        List {
            Section {
                ForEach(viewModel.movies) { movie in
                    NavigationLink {
                        MovieDetailView(movie: movie)
                            .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        MovieRowView(movie: movie)
                            .onAppear {
                                if movie == viewModel.movies.last {
                                    viewModel.fetchNextPage()
                                }
                            }
                            .alignmentGuide(.listRowSeparatorLeading) { _ in
                                return 0
                            }
                    }
                }
            } footer: {
                if viewModel.hasNextPage {
                    HStack {
                        Spacer()
                        Text("Loading...")
                            .font(.footnote)
                            .fontWeight(.medium)
                            .foregroundColor(.gray.opacity(0.8))
//                        ProgressView() // TODO: swiftui bug with using `ProgressView` inside a `List`
                        Spacer()
                    }
                    .alignmentGuide(.listRowSeparatorLeading) { _ in
                        return 0
                    }
                }
            }
        }
        .listStyle(.plain)
        .onChange(of: isSearching) { isSearching in
            if !isSearching {
                viewModel.cancelSearch()
            }
        }
    }
}

struct MovieRowView_Previews: PreviewProvider {
    static var previews: some View {
        MovieRowView(movie: MockDataMovies.shared.movie)
    }
}
