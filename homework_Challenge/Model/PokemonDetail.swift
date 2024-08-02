//
//  PokemonDetail.swift
//  homework_Challenge
//
//  Created by 임혜정 on 8/2/24.
//

import Foundation


struct PokemonDetailResponse: Codable {
    let id: Int
    let name: String
    let types: [TypeElement]
    let height: Int
    let weight: Int
    
    struct TypeElement: Codable {
        let type: pokemonType
    }
    
    struct pokemonType: Codable {
        let name: String
        let url: String
    }
}
