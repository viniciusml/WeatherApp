//
//  HTTPClient.swift
//  WeatherApp
//
//  Created by Vinicius Moreira Leal on 14/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation
import Alamofire

class HTTPClient: NetworkAdapter {
        
    func load(parameters: Coordinate? = nil, from url: URL, completion: @escaping (HTTPResult) -> Void) {
        
        let parameters: [String: Any] = ["lat": parameters?.latitude.description, "lon": parameters?.longitude.description, "appid": "b833ce501ff196a419ba285594863c6c"]
        
        Alamofire.request(url, method: .get, parameters: parameters)
            .responseJSON { result in
                
                guard let response = result.response else {
                    completion(.failure(WeatherLoader.Error.connectivity))
                    return
                }
                
                guard let data = result.data else {
                    completion(.failure(WeatherLoader.Error.connectivity))
                    return
                }
                
                completion(.success((data, response)))
        }
    }
}
