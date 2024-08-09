//
//  DetailViewModel.swift
//  homework_Challenge
//
//  Created by 임혜정 on 8/6/24.
//

import UIKit
import RxSwift
import RxCocoa

class DetailViewModel {
    private let disposeBag = DisposeBag()
    private let mainViewModel = MainViewModel()
    let detailInfoSubject = BehaviorRelay<PokemonDetailResponse?>(value: nil)
    private let pokemonSubject: BehaviorRelay<Pokemon>

    var image: Observable<UIImage?> {
        return pokemonSubject.flatMap { [weak self] pokemon -> Observable<UIImage?> in
            guard let self = self else { return Observable.just(nil) }
            return mainViewModel.getImage(for: pokemon)
        }
    }
    
    var id: Observable<String> {
        return pokemonSubject.map { "No.\($0.id)" }
    }
    
    var name: Observable<String> {
        return detailInfoSubject
            .compactMap { $0?.name }
    }
    
    var koreanName: Observable<String> {
        return name.map { PokemonTranslator.getKoreanName(for: $0) }
    }
    
    var height: Observable<String> {
        return detailInfoSubject
            .compactMap { $0?.height }
            .map { height in
                let heightInMeters = Double(height) / 10.0
                return String(format: "키: %.1fm", heightInMeters)
            }
    }
    
    var weight: Observable<String> {
        return detailInfoSubject
            .compactMap { $0?.weight }
            .map { weight in
                let weightInKg = Double(weight) / 10.0
                return String(format: "몸무게: %.1fkg", weightInKg)
            }
    }
    
    var types: Observable<[String]> {
        return detailInfoSubject.map { response in
            let typeNames = response?.types.compactMap { typeElement in
                PokemonTypeName(rawValue: typeElement.type.name.lowercased())?.displayName
            } ?? []
            
            if typeNames.isEmpty {
                return ["타입: 없음"]
            } else {
                return ["타입: " + typeNames.joined(separator: ", ")]
            }
            
        }
    }
    
    init(pokemon: Pokemon) {
        self.pokemonSubject = BehaviorRelay<Pokemon>(value: pokemon)
    }
    
    func setPokemon(_ pokemon: Pokemon) {
        pokemonSubject.accept(pokemon)
    }
    
    func fetchPokemonInfo() -> Observable<Void> {
        let pokemon = pokemonSubject.value
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(pokemon.id)") else {
            return Observable.error(NSError(domain: "Invalid URL", code: 0, userInfo: nil))
        }
        
        return NetworkManager.shared.fetch(url: url)
            .do(onSuccess: { [weak self] (response: PokemonDetailResponse) in
                self?.detailInfoSubject.accept(response)
            })
            .asObservable()
            .map { _ in () }
            .catch { error in
                return Observable.error(error)
            }
    }
}
