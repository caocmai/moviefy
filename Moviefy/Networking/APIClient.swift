//
//  Networking.swift
//  Moviefy
//
//  Created by Cao Mai on 4/29/20.
//  Copyright © 2020 Adriana González Martínez. All rights reserved.
//

import Foundation


struct APIClient{
    static let shared = APIClient()
    let session = URLSession(configuration: .default)
    
    let parameters = [
           "sort_by": "popularity.desc"
        
    ]
    
    
    func getPopularMovies(_ completion: @escaping (Result<[Movie]>) -> ()) {
        do{
          // Creating the request
            let request = try Request.configureRequest(from: .movies, with: parameters, and: .get, contains: nil)
                session.dataTask(with: request) { (data, response, error) in

                if let response = response as? HTTPURLResponse, let data = data {

                    let result = Response.handleResponse(for: response)
                    switch result {
                    case .success:
                        //Decode if successful
                        let result = try? JSONDecoder().decode(MovieApiResponse.self, from: data)
                        completion(Result.success(result!.movies))

                    case .failure:
                        completion(Result.failure(NetworkError.decodingFailed))
                    }
                }
            }.resume()
        }catch{
            completion(Result.failure(NetworkError.badRequest))
        }
    }
    
    
    func getUpcomingMovies(_ completion: @escaping (Result<[Movie]>) -> ()) {
        do{
          // Creating the request
            let request = try Request.configureRequest(from: .upcomingMovies, with: parameters, and: .get, contains: nil)
                session.dataTask(with: request) { (data, response, error) in

                if let response = response as? HTTPURLResponse, let data = data {

                    let result = Response.handleResponse(for: response)
                    switch result {
                    case .success:
                        //Decode if successful
                        let result = try? JSONDecoder().decode(MovieApiResponse.self, from: data)
                        
                        completion(Result.success(result!.movies))
                        
                    case .failure:
                        completion(Result.failure(NetworkError.decodingFailed))
                    }
                }
            }.resume()
        }catch{
            completion(Result.failure(NetworkError.badRequest))
        }
    }
}
