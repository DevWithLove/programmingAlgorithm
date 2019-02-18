//
//  ChainOfResponsibility.swift
//  ProgrammingAlgorithm
//
//  Created by Tony Mu on 18/02/19.
//  Copyright © 2019 Tony Mu. All rights reserved.
//

import Foundation

/*
 Chain of responsibility
 Organizes potential request processors in a sequence and decouples responders from callers.
 
 Motivation:
 Decouple request sender from receiver (such as responder chain)
 - Send requests throught a chain of objects
 - Candidates mya or may not handle the request
 - The request travels until it's processed or it reacheds the end of the chain
 */

//MARK: MessageProcessor Demo

protocol Message {
    var name: String {get}
}

protocol MessageProcessing: CustomStringConvertible {
    var nextProcessor: MessageProcessing? {get}
    init(next: MessageProcessing?)
    func process(message: Message)
    
    var messageIDs: [String]? {get}
}

struct ResponseMessage: Message {
    var name: String
}

// Use protocol extension to define default value for stored property and implemention of func
extension MessageProcessing {
    func process(message: Message) {
        if let shouldProcess = messageIDs?.contains(where: {$0 == message.name}), shouldProcess == true {
            print("Message processed by \(self)")
        } else if let next = nextProcessor {
            print("\(self) could not process message \(message)")
            next.process(message: message)
        } else {
            print("Next responder not set. Reached the end")
        }
    }
}

struct XMLProcessor: MessageProcessing {
    var nextProcessor: MessageProcessing?
    
    
    init(next: MessageProcessing?) {
        self.nextProcessor = next
    }
    
    var messageIDs: [String]? {
        return ["XML"]
    }
    
    var description: String {
        return "XMLProcessor"
    }
}

struct JSONProcessor: MessageProcessing {
    
    var nextProcessor: MessageProcessing?
    
    init(next: MessageProcessing?) {
        self.nextProcessor = next
    }
    
    var messageIDs: [String]? {
        return ["JSON"]
    }
    
    var description: String {
        return "JSONProcessor"
    }
}

struct ResponderChainEnd: MessageProcessing {
    var nextProcessor: MessageProcessing?
    
    init (next: MessageProcessing?) {}
    
    func process(message: Message) {
        print("Reached the end of the responder chain")
    }
    
    var messageIDs: [String]? {
        return nil
    }
    
    var description: String {
        return "ResponderChainEnd"
    }
}

fileprivate func MessageProcessorSample() {
    let message = ResponseMessage (name: "text")
    
    let responderChainEnd = ResponderChainEnd(next: nil)
    let jsonProcessor = JSONProcessor(next: responderChainEnd)
    let xmlProcessor = XMLProcessor(next: jsonProcessor)
    
    xmlProcessor.process(message: message)
    
}

//MARK: BackupService Demo

protocol WeatherService {
    var backupService: WeatherService? { get }
    init (backupService: WeatherService?)
    func fetchCurrentWeather(city: String, countyCode: String, completionHandler: (WeatherData?, WeatherServiceError?) -> Void)
}

struct WeatherData {
    let city: String
    let countryCode: String
    let weather: String
    let temp: Float
    let unit: TempUnit
}

enum TempUnit: CustomStringConvertible{
    case scientific
    case metric
    case imperial
    
    var description: String{
        switch self {
            case .scientific: return "Kelvin"
            case .metric: return "Celsius"
            case .imperial: return "Fahrenheit"
        }
    }
}

extension WeatherService {
    var backupService: WeatherService? {
        return nil
    }
}

enum WeatherServiceError: Error {
    case serviceDown
    case noData
    case unknown
}

extension WeatherServiceError: LocalizedError {
    var errorDescription: String {
        switch self {
        case .serviceDown: return "Service unavailable"
        case .noData: return "Could not retireve weather data"
        case .unknown: return "Unknown error occured"
        }
    }
}

struct OpenWeatherService: WeatherService, CustomStringConvertible {
    internal var backupService: WeatherService?
    
    init(backupService: WeatherService? = nil ) {
        self.backupService = backupService
    }
    
    func fetchCurrentWeather(city: String, countyCode: String, completionHandler: (WeatherData?, WeatherServiceError?) -> Void) {
        // if has error, try the backup service
        backupService?.fetchCurrentWeather(city: city, countyCode: countyCode, completionHandler: completionHandler)
    }
    
    var description: String {
        return "OpenWeatherService"
    }
}

struct AccuWeatherService: WeatherService, CustomStringConvertible {
    internal var backupService: WeatherService?
    
    init(backupService: WeatherService? = nil) {
        self.backupService = backupService
    }
    
    func fetchCurrentWeather(city: String, countyCode: String, completionHandler: (WeatherData?, WeatherServiceError?) -> Void) {
        // if has error, try the backup service
        backupService?.fetchCurrentWeather(city: city, countyCode: countyCode, completionHandler: completionHandler)
    }
    
    var description: String {
        return "OpenWeatherService"
    }
}

struct DarkWeatherService: WeatherService, CustomStringConvertible {
    internal var backupService: WeatherService?
    
    init(backupService: WeatherService? = nil) {
        self.backupService = backupService
    }
    
    func fetchCurrentWeather(city: String, countyCode: String, completionHandler: (WeatherData?, WeatherServiceError?) -> Void) {
        // if has error, try the backup service
        backupService?.fetchCurrentWeather(city: city, countyCode: countyCode, completionHandler: completionHandler)
    }
    
    var description: String {
        return "OpenWeatherService"
    }
}

struct WeatherServiceWrapper: WeatherService {
    init(backupService: WeatherService? = nil) {
    }
    
    func fetchCurrentWeather(city: String, countyCode: String, completionHandler: (WeatherData?, WeatherServiceError?) -> Void) {
        let darkService = DarkWeatherService()
        let accuService = AccuWeatherService(backupService: darkService)
        let openService = OpenWeatherService(backupService: accuService)
        
        openService.fetchCurrentWeather(city: city, countyCode: countyCode) { (data, error) in
            guard error == nil else {
                print("Error ...")
                return
            }
            
            print(data ?? "NoData")
        }
        
    }

}

//MARK: Cocoa Touch responder chain

// See the AppDelegate file

