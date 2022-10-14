//
//  Model.swift
//  AppCakeDemo
//
//  Created by Admin on 11/10/22.
//
//
import Foundation

enum CharacterRequest {
    struct Response: NetResponse, Codable{
        var statusCode: Int?
        var message: String?
        var results: [CharacterModel]?
        
        enum CodingKeys: String, CodingKey {
            case statusCode
            case results
        }
    }
    
    struct CharacterModel: Codable{
        var id: String
        var type: String
        var description: String
        var category: String
        var character_type: String
        var name: String
        var thumbnail: String
        var thumbnail_animated: String
        var motion_id: String?
        //var motions: String?
        var source: String
        
//        enum CodingKeys: String, CodingKey {
//            case id
//            case type
//            case description
//            case category
//            case character_type //= "character_type"
//            case name
//            case thumbnail
//            case thumbnail_animated// = "thumbnail_animated"
//            case motion_id //= "motion_id"
//            //case motions
//            case source
//        }
    }
}

protocol NetResponse: Codable {
    var statusCode: Int? { get }
    var message: String? { get }
}

