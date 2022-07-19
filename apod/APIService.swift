//
//  APIService.swift
//  apod
//
//  Created by vivek on 16/07/22.
//

import Foundation

enum APIError: String, Error {
    case transportError = "Unable to connect : Transport Error"
    case serverError = "Server error"
    case noData = "No Data"
    case decodingError = "unable to decode "
    case encodingError = "Unable To encode"
    case noNetwork = "No Network"
    case serverOverload = "Server is overloaded"
    case permissionDenied = "You don't have permission"
}

protocol APIServiceProtocol {
    func fetchAPodData( complete: @escaping ( _ success: Bool, _ photos: [Apod]?, _ error: APIError? )->() )
    func fetchTodayData( complete: @escaping ( _ success: Bool, _ photo: Apod?, _ error: APIError? )->() )
    func fetchSearchData( date: Date, complete: @escaping ( _ success: Bool, _ photo: Apod?, _ error: APIError? )->() )
}

class APIService: APIServiceProtocol {
    
    let API_KEY = "Ta1M5QOaiqkHuzC52ahrK6GOJ6lehfzvEzdl6TxC"
    func baseUrl()->String{
        return "https://api.nasa.gov/planetary/apod?"
    }
    
    func urlForTodayData()->String{
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        dateFormatter.string(from: Date())
        return baseUrl() + "api_key=" + API_KEY + "&date=" + dateFormatter.string(from: Date())
    }
    
    func urlForSearchDate(date: Date)->String{
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD hh:mm:ss"
        dateFormatter.timeStyle = .none
        let _ : String = dateFormatter.string(from: date)
         dateFormatter.dateFormat = "YYYY-MM-DD"
        let datenew = date.formatted(.iso8601.year().month().day().dateSeparator(.dash))
        return baseUrl() + "api_key=" + API_KEY + "&date=" + datenew
    }
    
    func fetchTodayData( complete: @escaping (Bool, Apod?, APIError?) -> ()) {
        let feedApiUrl = urlForTodayData()
        var request: URLRequest
        if(InternetConnectionManager.isConnectedToNetwork()){
            request = URLRequest(url: URL(string: feedApiUrl)!,
                                 cachePolicy: .reloadIgnoringCacheData,
                                     timeoutInterval: 10.0)
        }
        else{
            request = URLRequest(url: URL(string: feedApiUrl)!,
                                 cachePolicy: .returnCacheDataDontLoad,
                                     timeoutInterval: 10.0)

        }
        URLSession.shared.dataTask(with:request, completionHandler: { data, response, error in
            if error != nil {
                complete(false, nil, APIError.transportError)
                return
            }
            
            if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                complete(false, nil, APIError.serverError)
                return
            }
            guard let responsedata = data else {
                print("Unable to parse 1")
                return
            }
            do{
                let apod: Apod = try JSONDecoder().decode(Apod.self, from: responsedata)
                complete(true, apod, nil)
            }
            catch{
                print("Unable to parse 2 \(exception.self) ")
            }
        }).resume()
    }
    
    func fetchSearchData(date: Date, complete: @escaping (Bool, Apod?, APIError?) -> ()) {
        let feedApiUrl = urlForSearchDate(date: date)
        let request = URLRequest(url: URL(string: feedApiUrl)!,
                                 cachePolicy: .reloadRevalidatingCacheData,
                                 timeoutInterval: 10.0)
        URLSession.shared.dataTask(with:request, completionHandler: { data, response, error in
            if error != nil {
                complete(false, nil, APIError.transportError)
                return
            }
            
            if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                complete(false, nil, APIError.serverError)
                return
            }
            guard let responsedata = data else {
                print("Unable to parse 1")
                return
            }
            do{
                let apod: Apod = try JSONDecoder().decode(Apod.self, from: responsedata)
                complete(true, apod, nil)
            }
            catch{
                print("Unable to parse 2 \(exception.self) ")
            }
        }).resume()
        
    }
    
    func fetchAPodData( complete: @escaping ( _ success: Bool, _ photos: [Apod]?, _ error: APIError? )->() ) {
        let feedApiUrl = "https://api.nasa.gov/planetary/apod?api_key=Ta1M5QOaiqkHuzC52ahrK6GOJ6lehfzvEzdl6TxC&count=20"
        let request = URLRequest(url: URL(string: feedApiUrl)!,
                                 cachePolicy: .reloadRevalidatingCacheData,
                                 timeoutInterval: 10.0)
        URLSession.shared.dataTask(with:request, completionHandler: { data, response, error in
            if let error = error {
                complete(false, nil, APIError.transportError)
                return
            }
            
            if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                complete(false, nil, APIError.serverError)
                return
            }
            guard let responsedata = data else {
                print("Unable to parse 1")
                return
            }
            do{
                let apods: [Apod] = try JSONDecoder().decode([Apod].self, from: responsedata)
                complete(true, apods, nil)
            }
            catch{
                print("Unable to parse 2 \(exception.self) ")
            }
        }).resume()
    }
    
    
}
