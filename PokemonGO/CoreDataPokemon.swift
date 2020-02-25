//
//  CoreDataPokemon.swift
//  PokemonGO
//
//  Created by Guilherme Magnabosco on 18/01/20.
//  Copyright © 2020 Guilherme Magnabosco. All rights reserved.
//

import UIKit
import CoreData
class CoreDataPokemon {
    
    //recuperar o context
    func getContext() -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        
        return context!
        
    }
    
    func recuperarPokemonsCapturados(capturado: Bool) -> [Pokemon] {
        
        let context = self.getContext()

        let requisicao = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
        requisicao.predicate = NSPredicate(format: "capturado == %@", NSNumber(value: capturado))
        
        do {
            
            let pokemons = try context.fetch(requisicao) as [Pokemon]
            return pokemons
            
        } catch  {
            
        }
        
        return []
        
    }
    
    func recuperarTodosPokemons() -> [Pokemon] {
           
        let context = self.getContext()
        
        do {
            let pokemons = try context.fetch( Pokemon.fetchRequest() ) as! [Pokemon]
            
            if pokemons.count == 0 {
                
                self.adicionarTodosPokemons()
                return self.recuperarTodosPokemons()
                
            }
            
            return pokemons
        } catch  {
            
        }
        return []
    }
    
    
    func salvarPokemon(pokemon: Pokemon) {
        
        let context = self.getContext()
        pokemon.capturado = true
        
        do {
            try context.save()
        } catch  {
        }
        
        
    }
    //adicionar todos os pokemons
    func adicionarTodosPokemons() {
        
        let context = self.getContext()
        
        self.criaPokemon(nome: "Pikachu", nomeImagem: "pikachu-2", capturado: true)
        self.criaPokemon(nome: "Bellsprout", nomeImagem: "bellsprout", capturado: false)
        self.criaPokemon(nome: "Bullbasaur", nomeImagem: "bullbasaur", capturado: false)
        self.criaPokemon(nome: "Caterpie", nomeImagem: "caterpie", capturado: false)
        self.criaPokemon(nome: "Charmander", nomeImagem: "charmander", capturado: false)
        self.criaPokemon(nome: "Mew", nomeImagem: "mew", capturado: false)
        self.criaPokemon(nome: "Meowth", nomeImagem: "meowth", capturado: false)
        self.criaPokemon(nome: "Psyduck", nomeImagem: "psyduck", capturado: false)
        self.criaPokemon(nome: "Rattata", nomeImagem: "rattata", capturado: false)
        self.criaPokemon(nome: "Snorlax", nomeImagem: "snorlax", capturado: false)
        self.criaPokemon(nome: "Squirtle", nomeImagem: "squirtle", capturado: false)
        self.criaPokemon(nome: "Zubat", nomeImagem: "zubat", capturado: false)
        
        do {
            try context.save()
        } catch  {
            
        }

        
    }
    
    //criar ok pokemons
    func criaPokemon(nome: String, nomeImagem: String, capturado: Bool) {
        
        let context = self.getContext()
        let pokemon = Pokemon(context: context)
        pokemon.nome = nome
        pokemon.nomeImagem = nomeImagem
        pokemon.capturado = capturado
        
    }

    
}
