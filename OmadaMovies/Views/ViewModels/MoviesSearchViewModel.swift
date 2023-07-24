//
//  MoviesSearchViewModel.swift
//  OmadaMovies
//
//  Created by Jarod Luebbert on 7/23/23.
//

import Foundation
import Combine

class MoviesSearchViewModel: ObservableObject {
    
    /// the next page to fetch from the api with the current `searchTerm`
    private var nextPage: Int = 1
    private var totalPages: Int?
    private let client = TMDBClient()
    private let fetchNextPageAction = PassthroughSubject<Void, Never>()
    private var disposables = Set<AnyCancellable>()
    private var currentSearchTask: Task<Void, Never>?
    
    // MARK: Public
    
    @Published var searchTerm: String = ""
    @Published private(set) var movies: [Movie] = []
    @Published private(set) var searchError: Error? = nil
    private(set) var loading: Bool = false

    var noMoviesFound: Bool {
        return !searchTerm.isEmpty && movies.isEmpty && !loading
    }
    
    var hasNextPage: Bool {
        guard let total = totalPages else { return false }
        return nextPage <= total
    }
    
    init() {
        /// changes the loading state when the search term changes
        $searchTerm
            .removeDuplicates()
            .sink { term in
                self.loading = !term.isEmpty
            }
            .store(in: &disposables)
        
        /// reset the search if the search field is cleared
        $searchTerm
            .withPrevious()
            .sink { previousTerm, currentTerm in
                guard let previousTerm = previousTerm else { return }
                if !previousTerm.isEmpty && currentTerm.isEmpty {
                    self.resetSearch()
                }
            }
            .store(in: &disposables)
        
        /// when the search term changes or on the `fetchNextPage` action,
        /// fetch results from the client
        let shouldSearchWithSearchTerm = Publishers.Merge(
            $searchTerm
                .removeDuplicates()
                .debounce(for: 0.5, scheduler: RunLoop.main),
            fetchNextPageAction.withLatestFrom($searchTerm).map { $0.1 }
        )
        shouldSearchWithSearchTerm
            .filter { !$0.isEmpty }
            .withPrevious()
            .sink(receiveValue: { previousTerm, term in
                self.currentSearchTask = Task { @MainActor [weak self] in
                    guard let self = self else { return }
                    
                    if term != previousTerm {
                        self.resetSearch()
                    }
                    
                    do {
                        let response = try await self.client.movies(for: term, page: self.nextPage)
                        self.totalPages = response.totalPages
                        self.movies.append(contentsOf: response.results)
                        self.nextPage = response.page + 1
                        self.searchError = nil
                    } catch {
                        self.searchError = error
                    }
                    
                    self.loading = false
                }
            })
            .store(in: &disposables)
    }
    
    /// fetch the next page of results if there are any
    func fetchNextPage() {
        guard hasNextPage else { return }
        
        fetchNextPageAction.send()
    }
    
    /// cancel the current api request and reset the search results
    func cancelSearch() {
        currentSearchTask?.cancel()
        currentSearchTask = nil
        resetSearch()
    }
    
    // MARK: Private
    
    /// reset the search results
    private func resetSearch() {
        searchError = nil
        movies = []
        nextPage = 1
        totalPages = nil
    }
    
}
