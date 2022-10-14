//
//  SavedViewModel.swift
//  AppCakeDemo
//
//  Created by Admin on 13/10/22.
//

import Foundation
class SavedViewModel {
    var reloadList = {() -> () in}
    var errorMessage = {(message : String) -> () in}
    var arrayOfList : [CharacterRequest.CharacterModel] = []{
        didSet{
            reloadList()
        }
    }
    func requestSaved(limit: Int){
        CoreDataModel.shared.fetchData(limit: 0) { char, err in
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
