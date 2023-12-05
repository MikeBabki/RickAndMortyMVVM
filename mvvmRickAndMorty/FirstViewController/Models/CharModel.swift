//
//  CharModel.swift
//  mvvmRickAndMorty
//
//  Created by Макар Тюрморезов on 30.11.2023.
//

import Foundation

struct CharactersModel: Decodable, Equatable {
    
    var info: CharInformation?
    var results: [CharacterSet]?  
    
    static func == (lhs: CharactersModel, rhs: CharactersModel) -> Bool {
        lhs.info == rhs.info && lhs.results == rhs.results
    }
}

struct CharInformation: Decodable, Equatable {
    var pages: Int
}

struct CharacterSet: Decodable, Equatable {

    var id: Int?
    var name: String?
    var status: String?
    var species: String?
    var type: String?
    var gender: String?
    var origin: Origin
    var image: String?
    var location: Location
    
    static func == (lhs: CharacterSet, rhs: CharacterSet) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name && lhs.status == rhs.status && lhs.species == rhs.species && lhs.type == rhs.type && lhs.gender == rhs.gender && lhs.origin == rhs.origin && lhs.image == rhs.image && lhs.location == rhs.location
    }
}
struct Location: Decodable, Equatable {
    
    var name: String?
    var url: String?
}
struct Origin: Decodable, Equatable {
    var name: String?
    var url: String?
}
