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


extension APIClient {
    func createRequestToken(_ completion: @escaping (Result<AuthenticationTokenResponse>) -> ()){
        do{
            let request = try Request.configureRequest(from: .token, with: [:], and: .get, contains: nil)
            session.dataTask(with: request) { (data, response, error) in

              if let response = response as? HTTPURLResponse, let data = data {
                  let result = Response.handleResponse(for: response)
                  switch result {
                  case .success:
                      let result = try? JSONDecoder().decode(AuthenticationTokenResponse.self, from: data)
                      completion(Result.success(result!))
//                      print(result)

                  case .failure:
                      completion(Result.failure(NetworkError.decodingFailed))
                  }
              }
            }.resume()
        }catch{
            completion(Result.failure(NetworkError.badRequest))
        }
    }
    
    func createSession(requestToken: String, _ completion: @escaping (Result<CreateSessionResponse>) -> Void){}
    
    func getAccount(_ completion: @escaping (Result<Account>) -> ()){
            do{
                let request = try Request.configureRequest(from: .account, with: [:], and: .get, contains: nil)
                session.dataTask(with: request) { (data, response, error) in
                    
                    do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data!, options: [])
                        print(jsonObject)
                    } catch {
                        print(error.localizedDescription)
                    }
                  if let response = response as? HTTPURLResponse, let data = data {
                      let result = Response.handleResponse(for: response)
                      switch result {
                      case .success:
                          let result = try? JSONDecoder().decode(Account.self, from: data)
                          completion(Result.success(result!))
    //                      print(result)

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
