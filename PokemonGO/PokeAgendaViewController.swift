//
//  PokeAgendaViewController.swift
//  PokemonGO
//
//  Created by Guilherme Magnabosco on 19/01/20.
//  Copyright © 2020 Guilherme Magnabosco. All rights reserved.
//

import UIKit

class PokeAgendaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var pokemonsCapturados: [Pokemon] = []
    var pokemonsNaoCapturados: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let coreData = CoreDataPokemon()
        
        self.pokemonsCapturados = coreData.recuperarPokemonsCapturados(capturado: true)
        self.pokemonsNaoCapturados = coreData.recuperarPokemonsCapturados(capturado: false)
        
        print(String(self.pokemonsNaoCapturados.count))
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Capturados"
        } else {
            return "Não Capturados"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return self.pokemonsCapturados.count
            
        } else if section == 1 {
            
            return self.pokemonsNaoCapturados.count
            
        }
        return -1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let pokemon: Pokemon
        
        if indexPath.section == 0 {
            pokemon = self.pokemonsCapturados[indexPath.row]
        } else {
            pokemon =  self.pokemonsNaoCapturados[indexPath.row]
        }
        
        let celula = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "celula")
        celula.textLabel?.text = pokemon.nome
        celula.imageView?.image = UIImage(named: pokemon.nomeImagem!)
        
        return celula
        
    }
    
    @IBAction func voltarMapa(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
}
