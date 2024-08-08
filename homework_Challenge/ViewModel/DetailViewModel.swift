//
//  DetailViewModel.swift
//  homework_Challenge
//
//  Created by 임혜정 on 8/6/24.
//

import Foundation
import RxSwift
import RxCocoa

class DetailViewModel {
    private let disposeBag = DisposeBag()
    
    let detailInfoSubject = BehaviorRelay<PokemonDetailResponse?>(value: nil)
    private let pokemonSubject: BehaviorRelay<Pokemon>
    //    let error = PublishSubject<Error>()
    
    var id: Observable<String> {
        return pokemonSubject.map { "No.\($0.id)" }
    }
    var name: Observable<String> {
        return detailInfoSubject
            .compactMap { $0?.name }
    }
    
    var height: Observable<String> {
        return detailInfoSubject
            .compactMap { $0?.height }
            .map { "\($0)" }
    }
    
    var weight: Observable<String> {
        return detailInfoSubject
            .compactMap { $0?.weight }
            .map { "\($0)" }
    }
    
    var types: Observable<[String]> {
        return detailInfoSubject.compactMap { $0?.types.map { "\($0.type.name)"} }
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
                print("Error fetching pokemon info: \(error.localizedDescription)")
                return Observable.error(error)
            }
    }
}
