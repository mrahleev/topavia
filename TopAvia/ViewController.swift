//
//  ViewController.swift
//  TopAvia
//
//  Created by Maksim Rahleev on 09/07/2019.
//  Copyright © 2019 Maksim Rahleev. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkAvailableHotSaleTrips()
    }
    
    private func checkAvailableHotSaleTrips() {
        getDepartureCities(path: TextConstants.departureCityUrlPath)
        getArrivalCountries(path: TextConstants.arrivalCountriesUrlPath, aID: 630)
        getArrivalCities(path: TextConstants.arrivalCityUrlPath, aID: 630, countryID: 5)
        getAtoBDate(path: TextConstants.abDateUrlPath, aID: 630, bID: 629)
        getBtoADate(path: TextConstants.baDataUrlPath, bID: 629, aID: 630, backDate: Date())
        getCurrency(path: TextConstants.currencyUrlPath)
    }
    
    private func getDepartureCities(path: String) {
        NetworkManager<[City]>().load(path: path) { result in
            print(result)
        }
    }
    
    private func getArrivalCountries(path: String, aID: Int) {
        let pathParams = [aID.toString(), "countries"]
        
        NetworkManager<[Country]>().load(path: path, pathParams: pathParams) { result in
            print(result)
        }
    }
    
    private func getArrivalCities(path: String, aID: Int, countryID: Int) {
        let pathParams = [aID.toString(), countryID.toString()]
        
        NetworkManager<[City]>().load(path: path, pathParams: pathParams) { result in
            print(result)
        }
    }
    
    private func getAtoBDate(path: String, aID: Int, bID: Int) {
        let pathParams = [aID.toString(), bID.toString()]
        
        NetworkManager<[String]>().load(path: path, pathParams: pathParams) { result in
            switch result {
            case .success(let datesStrings):
                let dates = self.serverDatesStringsToDates(datesStrings)
                print(dates)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getBtoADate(path: String, bID: Int, aID: Int, backDate: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let backDateString = dateFormatter.string(from: backDate)
        
        let pathParams = [bID.toString(), aID.toString(), backDateString]
        
        NetworkManager<[String]>().load(path: path, pathParams: pathParams) { result in
            switch result {
            case .success(let datesStrings):
                let dates = self.serverDatesStringsToDates(datesStrings)
                print(dates)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getCurrency(path: String) {
        NetworkManager<[Currency]>().load(path: path) { result in
            print(result)
        }
    }
    
    // MARK: - Helpers
    
    private func serverDatesStringsToDates(_ datesStrings: [String]) -> [Date] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return datesStrings.compactMap { dateFormatter.date(from: $0) }
    }
    
    //    private func getAllAvailableFlights(path: String) {
    //        checkAvailableHotSaleTrips()
    //        NetworkManager<Flight>().load(path: path) { result in
    //            print(result)
    //        }
    //    }
}

