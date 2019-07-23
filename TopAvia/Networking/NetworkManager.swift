//
//  NetworkManager.swift
//  TopAvia
//
//  Created by Maksim Rahleev on 10/07/2019.
//  Copyright © 2019 Maksim Rahleev. All rights reserved.
//

import Foundation

typealias Completion<T> = (Result<T, Error>) -> Void
typealias URLParameters = [String: String]

class NetworkManager {

    func get<T: Decodable>(request: URLRequestConvertible,
                           dateFormat: String? = nil,
                           completion: @escaping Completion<T>) {

        do {
            let urlRequest = try request.asURLRequest()

            URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                } else if let data = data {
                    do {
                        let decoder = JSONResponseDecoder.decoder(dateFormat: dateFormat)
                        let object = try decoder.decode(T.self, from: data)
                        completion(.success(object))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }.resume()

        } catch {
            completion(.failure(error))
        }
    }
}
