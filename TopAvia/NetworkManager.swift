//
//  NetworkManager.swift
//  TopAvia
//
//  Created by Maksim Rahleev on 10/07/2019.
//  Copyright © 2019 Maksim Rahleev. All rights reserved.
//

import Foundation

public typealias NMResult<T> = Result<T, Error>

class NetworkManager<T: Decodable> {
    private let baseURL = "http://online.toptour.by:9000/TourSearchOwin/"

    func load(path: String, pathParams: [String] = [], queryParams: [String: String] = [:], completion: @escaping (NMResult<T>) -> Void) {
        guard var url = URL(string: baseURL) else { return }
        url.appendPathComponent(path)
        pathParams.forEach { pathParam in
            url.appendPathComponent(pathParam)
        }
        url.appendQueryParams(queryParams)

        // URL(string: "https://www.apple.com")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let object = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(object))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
