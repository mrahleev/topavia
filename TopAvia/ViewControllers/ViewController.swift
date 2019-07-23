//
//  ViewController.swift
//  TopAvia
//
//  Created by Maksim Rahleev on 09/07/2019.
//  Copyright © 2019 Maksim Rahleev. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    private let fetchService: FetchServiceProtocol = FetchService()

    private var aCities = [City]()
    private var bCoutries = [Country]()
    private var bCities = [City]()
    private var abDates = [Date]()
    private var baDates = [Date]()
    private var flights = [Flight]()

    private let sema = DispatchSemaphore(value: 0)

    // MARK: -

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.global().async {
            self.test()
        }
    }

    // MARK: - Helpers

    private func test() {
        fetchService.getDepartureCities { (result) in
            print(result)
            self.aCities = try! result.get()
            self.sema.signal()
        }
        sema.wait()

        fetchService.getArrivalCountries(departureCityId: aCities[0].key) { (result) in
            print(result)
            self.bCoutries = try! result.get()
            self.sema.signal()
        }
        sema.wait()

        fetchService.getArrivalCities(departureCityId: aCities[0].key, arrivalCountryId: bCoutries[0].key) { (result) in
            print(result)
            self.bCities = try! result.get()
            self.sema.signal()
        }
        sema.wait()

        fetchService.getDatesAtoB(aId: aCities[0].key, bId: bCities[0].key) { (result) in
            print(result)
            self.abDates = try! result.get()
            self.sema.signal()
        }
        sema.wait()

        fetchService.getDatesBtoA(aId: aCities[0].key, bId: bCities[0].key, abDate: abDates[0]) { (result) in
            print(result)
            self.baDates = try! result.get()
            self.sema.signal()
        }
        sema.wait()

        print("FINISH URA")
    }
}
