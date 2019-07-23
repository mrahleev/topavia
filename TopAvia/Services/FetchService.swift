//
//  FetchService.swift
//  TopAvia
//
//  Created by Maksim Rahleev on 23/07/2019.
//  Copyright © 2019 Maksim Rahleev. All rights reserved.
//

import Foundation

protocol FetchServiceProtocol {
    func getDepartureCities(completion: @escaping Completion<[City]>)
    func getArrivalCountries(departureCityId: Int, completion: @escaping Completion<[Country]>)
    func getArrivalCities(departureCityId: Int, arrivalCountryId: Int, completion: @escaping Completion<[City]>)
    func getDatesAtoB(aId: Int, bId: Int, completion: @escaping Completion<[Date]>)
    func getDatesBtoA(aId: Int, bId: Int, abDate: Date, completion: @escaping Completion<[Date]>)
}

class FetchService: FetchServiceProtocol {
    private let networkManager = NetworkManager()

    func getDepartureCities(completion: @escaping Completion<[City]>) {
        let request = APIRouter.getDepartureCities
        networkManager.get(request: request, completion: completion)
    }

    func getArrivalCountries(departureCityId: Int, completion: @escaping Completion<[Country]>) {
        let request = APIRouter.getArrivalCountries(departureCityId: departureCityId)
        networkManager.get(request: request, completion: completion)
    }

    func getArrivalCities(departureCityId: Int, arrivalCountryId: Int, completion: @escaping Completion<[City]>) {
        let request = APIRouter.getArrivalCities(departureCityId: departureCityId, arrivalCountryId: arrivalCountryId)
        networkManager.get(request: request, completion: completion)
    }

    func getDatesAtoB(aId: Int, bId: Int, completion: @escaping Completion<[Date]>) {
        let request = APIRouter.getDatesAtoB(aCityId: aId, bCityId: bId)
        networkManager.get(request: request, dateFormat: "dd.MM.yyyy", completion: completion)
    }

    func getDatesBtoA(aId: Int, bId: Int, abDate: Date, completion: @escaping Completion<[Date]>) {
        let request = APIRouter.getDatesBtoA(aCityId: aId, bCityId: bId, abDate: abDate)
        networkManager.get(request: request, dateFormat: "dd.MM.yyyy", completion: completion)
    }
}
