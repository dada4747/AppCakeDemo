//
//  CharactersViewModel.swift
//  AppCakeDemo
//
//  Created by Admin on 11/10/22.
//

import Foundation
class CharacterViewModel {
    var reloadList = {() -> () in}
    var errorMessage = {(message : String) -> () in}
    var arrayOfList : [CharacterRequest.CharacterModel] = [] {
        didSet{
            reloadList()
        }
    }
 
    func requestCharacters(limit: Int){
        NetworkManager().fetchCharacters(limit: limit) { characs, err in
            if err == ""{
                if let characters = characs{
                    self.arrayOfList.append(contentsOf: characters)// = characters
                }
            }
            else{
                print("error occurred: \(err)")
            }
            
        }
    }

    func requestAnimations(limit: Int){
        NetworkManager().fetchAnimations(limit: limit) { anims, err in
            if err == ""{
                if let animations = anims{
                    self.arrayOfList.append(contentsOf: animations)// = animations
                }
            }
            else{
                print("error occurred: \(err)")
            }
        }
    }
    func requestSaved(limit: Int){
        CoreDataModel.shared.fetchData(limit: 1) { char, err in
            if err == ""{
                if let chars = char{
                    self.arrayOfList = chars
                }
            }
            else{
                print("error occurred: \(err)")
            }
        }
    }

}
