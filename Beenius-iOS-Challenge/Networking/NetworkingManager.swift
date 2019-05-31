//
//  NetworkingManager.swift
//  Beenius-iOS-Challenge
//
//  Created by Klemen Košir on 31/05/2019.
//  Copyright © 2019 Klemen Košir. All rights reserved.
//

import Foundation

typealias NetworkRequestCompletion<T: Decodable> = (_ result: Result<T, Error>) -> Void


class NetworkingManager {
    
    static let shared = NetworkingManager()
    
    private var session: URLSession!
    
    private init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }
    
    
    func makeRequest<T: Decodable>(_ request: NetworkRequest, completion: @escaping NetworkRequestCompletion<T>) {
        
        var urlRequest = URLRequest(url: request.url)
        urlRequest.httpMethod = request.httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = request.headerFields
        urlRequest.httpBody = request.httpBody

        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            do {
                if let d = data {
                    let decoded = try JSONDecoder().decode(T.self, from: d)
                    DispatchQueue.main.async {
                        completion(.success(decoded))
                    }
                }
                else {
                    throw error ?? NetworkError.unknown
                }
            }
            catch let err {
                if let d = data {
                    print("[RESPONSE DATA]: \(String(data: d, encoding: .utf8) ?? "nil")")
                }
                DispatchQueue.main.async {
                    completion(.failure(err))
                }
            }
            
        }
        task.resume()
        
    }
    
}
