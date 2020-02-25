//
//  ViewController.swift
//  PokemonGO
//
//  Created by Guilherme Magnabosco on 17/01/20.
//  Copyright © 2020 Guilherme Magnabosco. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapa: MKMapView!
    var gerenciadorLocalizacao = CLLocationManager()
    var contador = 0
    var coreDataPokemon: CoreDataPokemon!
    var pokemons: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapa.delegate = self
        gerenciadorLocalizacao.delegate = self // quem vai cuidar dos objetos e a propria classe
        gerenciadorLocalizacao.requestWhenInUseAuthorization()
        gerenciadorLocalizacao.startUpdatingLocation()
        
        //recuperar pokemons
        self.coreDataPokemon = CoreDataPokemon()
        self.pokemons = self.coreDataPokemon.recuperarTodosPokemons()
        
        // Exibir pokemons
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
            
            if let coordenadas = self.gerenciadorLocalizacao.location?.coordinate {
                
                let totalPokemons = UInt32(self.pokemons.count)
                let indicePokemonAleatorio = arc4random_uniform( totalPokemons )
                
                let pokemon = self.pokemons[ Int(indicePokemonAleatorio) ]
                
                let anotacao = PokemonAnotacao(coordenadas: coordenadas, pokemon: pokemon)
                
                let latAleatoria = ((Double(arc4random_uniform(400)) - 200)/100000.0)
                let longAleatoria = ((Double(arc4random_uniform(400)) - 200)/100000.0)

                anotacao.coordinate.latitude += latAleatoria
                anotacao.coordinate.longitude += longAleatoria
                
                self.mapa.addAnnotation(anotacao)
            }
            
            
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let anotacaoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        if annotation is MKUserLocation {
            
            anotacaoView.image = UIImage(named: "player")
            
        } else {
            let pokemon = (annotation as! PokemonAnotacao).pokemon
            
            anotacaoView.image = UIImage(named: pokemon.nomeImagem!)
            
        }
        
        var frame = anotacaoView.frame
        frame.size.height = 40
        frame.size.width = 40
        
        anotacaoView.frame = frame
        
        return anotacaoView
    }

    //chamado quando se pressiona uma anotacao
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let anotacao = view.annotation
        let pokemon = (view.annotation as! PokemonAnotacao).pokemon
        
        mapView.deselectAnnotation(anotacao, animated: true)
    
        if anotacao is MKUserLocation {
            return
        }
        
        if let coordAnotacao = anotacao?.coordinate {
            let regiao = MKCoordinateRegion(center: coordAnotacao ,latitudinalMeters: 200, longitudinalMeters: 200)
            mapa.setRegion(regiao, animated: true)
        }
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            
            if let coord = self.gerenciadorLocalizacao.location?.coordinate {
                       
                if (self.mapa.visibleMapRect).contains(MKMapPoint(coord)) {
                    self.coreDataPokemon.salvarPokemon(pokemon: pokemon)
                    self.mapa.removeAnnotation(anotacao!)
                    
                    let alertController = UIAlertController(title: "Você capturou um POKIMON PORRA", message: "Você capturou o pokemon: \(pokemon.nome!)", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController.addAction(ok)
                    
                    self.present(alertController, animated: true, completion: nil)
                    } else {
                    
                        let alertController = UIAlertController(title: "Você não capturou o POKIMON!", message: "Você precisa se aproximar mais para capturar o \(pokemon.nome!)", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alertController.addAction(ok)
                        
                        self.present(alertController, animated: true, completion: nil)
                        print("Voce NAO pode capturar o pokemon")
                    }

            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if contador < 5 {
        
           self.centralizar()
            contador += 1
            
        } else {
            
            gerenciadorLocalizacao.stopUpdatingLocation()

        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status != .authorizedWhenInUse && status != .notDetermined{
            
            //alerta
            let alertController = UIAlertController(title: "Permissao de localizacao", message: "Para que voce possa caçar pokemons, habilite essa merda", preferredStyle: .alert)
            let acaoConfiguracoes = UIAlertAction(title: "Abrir configuraçōes", style: .default) { (alertaConfiguracoes) in
                
                if let configuracoes = NSURL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(configuracoes as URL)
                }
                
            }
            
            let acaoCancelar = UIAlertAction(title: "cancelar", style: .default, handler: nil)
            
            alertController.addAction(acaoConfiguracoes)
            alertController.addAction(acaoCancelar)
            
            present(alertController, animated: true, completion: nil)
        }
        
    }
    func centralizar() {
        
        if let coordenadas = gerenciadorLocalizacao.location?.coordinate {
            let regiao = MKCoordinateRegion(center: coordenadas, latitudinalMeters: 200, longitudinalMeters: 200)
            mapa.setRegion(regiao, animated: true)
        }
        
    }
    
    @IBAction func centralizarJogador(_ sender: Any) {
        
        self.centralizar()
        
    }
    
    @IBAction func abrirPokedex(_ sender: Any) {
    
    }
    
}

