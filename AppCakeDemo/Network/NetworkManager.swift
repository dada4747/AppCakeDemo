//
//  NetworkCall.swift
//  AppCakeDemo
//
//  Created by Admin on 11/10/22.
//

import Foundation
import UIKit

struct Constants{
    static var baseURL = "https://www.mixamo.com/api/v1/products"
}

class NetworkManager{
    static var shared = NetworkManager()
    let cache  = NSCache<NSString, UIImage>()
    let cache2 = NSCache<NSString, NSData>()
    func fetchCharacters(limit: Int, completion: @escaping ([CharacterRequest.CharacterModel]?, String) -> Void){
        let params = ["limit": "10", "page": "\(limit)", "type": "Character"] as [String : Any]
        requestHandler.get(resource: "", params).response { response in
            switch response.result{
            case .success:
                do{
                    let decodedResponse = try JSONDecoder().decode(CharacterRequest.Response.self, from: response.data!)
                    if let result = decodedResponse.results{
                        completion(result, "")
                    }
                } catch let err{
                    print("error parsing: \(err)")
                }
                
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    
    func fetchAnimations(limit: Int, completion: @escaping ([CharacterRequest.CharacterModel]?, String) -> Void){
        let params = ["limit": "10", "page": "\(limit)", "type": "Motion,MotionPack"]
        requestHandler.get(resource: "", params).response { response in
            switch response.result{
            case .success:
                do{
                    let decodedResponse = try JSONDecoder().decode(CharacterRequest.Response.self, from: response.data!)
                    
                    if let result = decodedResponse.results{
                        completion(result, "")
                    }
                } catch let err{
                    print("error parsing: \(err)")
                }
                
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    func downloadImage(from urlString: String,imgcompletion: @escaping (UIImage?, Data?, String)-> Void) {
            let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey), let data = cache2.object(forKey: cacheKey) {
                
            imgcompletion(image, data as Data, "")
                
//                self.image = image
                return
            }
            
            guard let url = URL(string: urlString) else { return }
            
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self else { return }
                if error != nil { return }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
                guard let data = data else { return }
                
                guard let image = UIImage(data: data) else { return }
                self.cache.setObject(image, forKey: cacheKey)
                self.cache2.setObject(data as NSData, forKey: cacheKey)
                imgcompletion(image, data, "")
            }
            
            task.resume()
        }
}
