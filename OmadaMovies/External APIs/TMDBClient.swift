//
//  TMDBClient.swift
//  OmadaMovies
//
//  Created by Jarod Luebbert on 7/23/23.
//

import Foundation

class TMDBClient {
    
    enum TMDBClientError: Error {
        case misformedURL(path: String)
        case invalidResponse(response: URLResponse?)
    }
    
    private let apiKey = "b11fc621b3f7f739cb79b50319915f1d" // TODO: consider storing this securely
    private let decoder: JSONDecoder
    
    init() {
        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
    }
    
    // MARK: API
    
    /// search for movies, starting page defaults to 1
    func movies(for searchTerm: String, page: Int = 1) async throws -> MoviesResponse {
        let request = try request(for: "search/movie",
                                  httpMethod: "GET",
                                  queryItems: [
                                    URLQueryItem(name: "query", value: searchTerm),
                                    URLQueryItem(name: "page", value: "\(page)"),
                                    URLQueryItem(name: "include_adult", value: "false")
                                  ])
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200 else {
            throw TMDBClientError.invalidResponse(response: response)
        }
        
        let decodedMovies = try decoder.decode(MoviesResponse.self, from: data)

        return decodedMovies
    }
    
    // MARK: Private
    
    /// generic helper for forming a request to the TMDB api
    private func request(for path: String, httpMethod: String, queryItems: [URLQueryItem]) throws -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.themoviedb.org"
        urlComponents.path = "/3/\(path)"
        var allQueryItems = queryItems
        allQueryItems.append(URLQueryItem(name: "api_key", value: apiKey))
        urlComponents.queryItems = allQueryItems
        
        guard let url = urlComponents.url else { throw TMDBClientError.misformedURL(path: path) }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = [
            "accept": "application/json"
        ]
        urlRequest.httpMethod = httpMethod
        urlRequest.cachePolicy = .useProtocolCachePolicy
        return urlRequest
    }
    
}

extension TMDBClient {
    struct MoviesResponse: Decodable {
        let page: Int
        let totalPages: Int
        let totalResults: Int
        let results: [Movie]
    }
}
