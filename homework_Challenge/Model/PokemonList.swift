//
//  PokemonList.swift
//  homework_Challenge
//
//  Created by 임혜정 on 8/2/24.
//

import Foundation

struct PokemonListResponse: Codable {
    let results: [Pokemon]
}

struct Pokemon: Codable, Identifiable {
    let name: String
    let url: String
    
    var id: Int {
        return Int(url.split(separator: "/").last ?? "0") ?? 0 // id번호 계산
    }
}
