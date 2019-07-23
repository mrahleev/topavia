//
//  APIRouter.swift
//  TopAvia
//
//  Created by Maksim Rahleev on 23/07/2019.
//  Copyright © 2019 Maksim Rahleev. All rights reserved.
//

import Foundation

enum APIRouter {
    case getDepartureCities
    case getArrivalCountries(departureCityId: Int)
    case getArrivalCities(departureCityId: Int, arrivalCountryId: Int)
    case getDatesAtoB(aCityId: Int, bCityId: Int)
    case getDatesBtoA(aCityId: Int, bCityId: Int, abDate: Date)
}

extension APIRouter {

    var basePath: String {
        return "http://online.toptour.by:9000/TourSearchOwin/individuals/avia/twoway"
    }

    var path: String {
        switch self {
        case .getDepartureCities:
            return "/departures"
        case .getArrivalCountries(let departureCityId):
            return String(format: "arrivals/%d/countries", departureCityId)
        case .getArrivalCities(let departureCityId, let arrivalCountryId):
            return String(format: "arrivals/%d/%d", departureCityId, arrivalCountryId)
        case .getDatesAtoB(let aCityId, let bCityId):
            return String(format: "departures/dates/%d/%d", aCityId, bCityId)
        case .getDatesBtoA(let aCityId, let bCityId, let abDate):
            let abDateString = RequestDateFormatter.shared.string(from: abDate)
            return String(format: "arrivals/dates/%d/%d/%@", aCityId, bCityId, abDateString)
        }
    }

    var queryParams: URLParameters? {
        return nil
    }
}

extension APIRouter: URLRequestConvertible {

    func asURLRequest() throws -> URLRequest {
        guard var baseURL = URL(string: basePath) else {
            throw URLError(.badURL)
        }

        baseURL.appendPathComponent(path)

        if let queryParams = queryParams {
            baseURL.appendQueryParams(queryParams)
        }
        
        return URLRequest(url: baseURL)
    }
}
