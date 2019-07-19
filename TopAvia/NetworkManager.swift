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

    func load(path: String, params: [String: String] = [:], completion: @escaping (NMResult<T>) -> Void) {

        guard var url = URL(string: baseURL) else { return }
        url.appendPathComponent(path)
        url.appendQueryParams(params)

        URLSession.shared.dataTask(with: URL(string: "https://www.apple.com")!) { (data, response, error) in
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
