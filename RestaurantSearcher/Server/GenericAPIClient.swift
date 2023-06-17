//
//  GenericAPIClient.swift
//  RestaurantSearcher
//
//  Created by cmStudent on 2023/06/06.
//

import Foundation
import Alamofire

class GenericAPIClient {
    
    static let shared = GenericAPIClient()
    
    private let baseUrl = "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/"
    private let genreUrl = "https://webservice.recruit.co.jp/hotpepper/genre/v1/"
    private let shopAreaUrl = "https://webservice.recruit.co.jp/hotpepper/large_area/v1/"
    
    func request<T: Decodable>(params: [String: Any], type: T.Type, completion: @escaping (T) -> Void) {
        
        let url = baseUrl + "?"
        // MARK: - range=5は　3000m以内の検索
        // MARK: - formatは　xml または json または jsonp。
        var params = params
        params["key"] = "39a612a793e874a7"
        //params["range"] = "5"
        params["count"] = "100"
        params["format"] = "json"
        
        let request = AF.request(url, method: .get, parameters: params)
        
        //responseJSON(queue:dataPreprocessor:emptyResponseCodes:emptyRequestMethods:options:completionHandler:)' is deprecated: responseJSON deprecated and will be removed in Alamofire 6. Use responseDecodable instead.
        request.responseData { (response) in
            guard let statusCode = response.response?.statusCode else { return }
            
            //check status code
            if statusCode == 200 {
                
                do {
                    
                    guard let data = response.data else { return }
                    let decoder = JSONDecoder()
                    let value = try decoder.decode(T.self, from: data)
                    
                    completion(value)
                    
                } catch let jsonError {
                    print("jsonError: ", jsonError)
                }
            }
        }
    }
    func requestGenre<T: Decodable>(params: [String: Any], type: T.Type, completion: @escaping (T) -> Void) {
        
        let url = genreUrl + "?"
        // MARK: - range=5は　3000m以内の検索
        // MARK: - formatは　xml または json または jsonp。
        var params = params
        params["key"] = "39a612a793e874a7"
        params["count"] = "50"
        params["format"] = "json"
        
        let request = AF.request(url, method: .get, parameters: params)
        
        //responseJSON(queue:dataPreprocessor:emptyResponseCodes:emptyRequestMethods:options:completionHandler:)' is deprecated: responseJSON deprecated and will be removed in Alamofire 6. Use responseDecodable instead.
        request.responseData { (response) in
            guard let statusCode = response.response?.statusCode else { return }
            
            //check status code
            if statusCode == 200 {
                
                do {
                    
                    guard let data = response.data else { return }
                    let decoder = JSONDecoder()
                    let value = try decoder.decode(T.self, from: data)
                    
                    completion(value)
                    
                } catch let jsonError {
                    print("jsonError: ", jsonError)
                }
            }
        }
    }
    
    func requestShopArea<T: Decodable>(params: [String: Any], type: T.Type, completion: @escaping (T) -> Void) {
        
        let url = shopAreaUrl + "?"
        // MARK: - range=5は　3000m以内の検索
        // MARK: - formatは　xml または json または jsonp。
        var params = params
        params["key"] = "39a612a793e874a7"
        params["count"] = "50"
        params["format"] = "json"
        
        let request = AF.request(url, method: .get, parameters: params)
        
        //responseJSON(queue:dataPreprocessor:emptyResponseCodes:emptyRequestMethods:options:completionHandler:)' is deprecated: responseJSON deprecated and will be removed in Alamofire 6. Use responseDecodable instead.
        request.responseData { (response) in
            guard let statusCode = response.response?.statusCode else { return }
            
            //check status code
            if statusCode == 200 {
                
                do {
                    
                    guard let data = response.data else { return }
                    let decoder = JSONDecoder()
                    let value = try decoder.decode(T.self, from: data)
                    
                    completion(value)
                    
                } catch let jsonError {
                    print("jsonError: ", jsonError)
                }
            }
        }
    }
}

