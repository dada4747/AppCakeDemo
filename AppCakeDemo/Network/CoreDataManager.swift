//
//  UserDefaultModel.swift
//  AppCakeDemo
//
//  Created by Admin on 13/10/22.
//

import Foundation
import UIKit
import CoreData

class CoreDataModel {
    var viewModel = CharacterViewModel()
    static var shared = CoreDataModel()
    private init(){}
    
    func createCoreData(model: CharacterRequest.CharacterModel){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let userEntity = NSEntityDescription.entity(forEntityName: "CharacterModel", in: managedContext)!
        
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        user.setValue(model.id, forKey: "id")
        user.setValue(model.description, forKey: "desc")
        user.setValue(model.thumbnail_animated, forKey: "thumbnailAnimated")
        user.setValue(model.name, forKey: "name")
        user.setValue(model.type, forKey: "type")
        user.setValue(model.thumbnail, forKey: "thumbnail")
        user.setValue(model.category, forKey: "category")
        user.setValue(model.character_type, forKey: "characterType")
        user.setValue(model.source, forKey: "source")
        
        do{
            try managedContext.save()
        }catch let error as NSError {
            print("could not saved. \(error), \(error.userInfo)")
        }
    }
    
    func fetchData(limit: Int, completion: @escaping ([CharacterRequest.CharacterModel]?, String) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CharacterModel")
        do {
            let result = try managedContext.fetch(fetchRequest)
            var array : [CharacterRequest.CharacterModel] = []
            for data in result as! [NSManagedObject] {
                var model : [String: String] = [:]
                model["id"] = data.value(forKey: "id") as? String
                model["description"] = data.value(forKey: "desc") as? String
                model["thumbnail_animated"] = data.value(forKey: "thumbnailAnimated") as? String
                model["name"] = data.value(forKey: "name") as? String
                model["type"] = data.value(forKey: "type") as? String
                model["thumbnail"] = data.value(forKey: "thumbnail") as? String
                model["category"] = data.value(forKey: "category") as? String
                model["character_type"] = data.value(forKey: "characterType") as? String
                model["source"] = data.value(forKey: "source") as? String
                var myJsonString = ""
                do {
                    let data =  try JSONSerialization.data(withJSONObject: model, options: .prettyPrinted)
                    myJsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                } catch {
                    completion(nil, error.localizedDescription)

                    print(error.localizedDescription)
                }
                
                let jsonData = Data(myJsonString.utf8)
                
                let decoder = JSONDecoder()
                
                do {
                    let charModel = try decoder.decode(CharacterRequest.CharacterModel.self, from: jsonData)
                    array.append(charModel)
                } catch {
                    completion(nil, error.localizedDescription)

                    print(error.localizedDescription)
                }
            }
            completion(array, "")

            print(array)
        }catch {
            completion(nil, error.localizedDescription)

            print("failed")
        }
    }
    
    func deleteData(id: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CharacterModel")
        fetchrequest.predicate = NSPredicate(format: "id = %@", id)
        do {
            let test = try managedContext.fetch(fetchrequest)
            let objectToDelete = test[0] as! NSManagedObject
            managedContext.delete(objectToDelete)
            do{
                try managedContext.save()
            }catch{
                print(error)
            }
        }catch {
            print(error)
        }
    }
    func checkIsAvaibleInCoreData(id: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CharacterModel")
        fetchRequest.fetchLimit =  1
        fetchRequest.predicate = NSPredicate(format: "id == %@" ,id)
        //            fetchRequest.predicate = NSPredicate(format: "type == %@" ,type)
        
        do {
            let count = try managedContext.count(for: fetchRequest)
            if count > 0 {
                return true
            }else {
                return false
            }
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
    }
    
    func checkAndDelete(model: CharacterRequest.CharacterModel){
        if CoreDataModel.shared.checkIsAvaibleInCoreData(id: model.id){
            CoreDataModel.shared.deleteData(id: model.id)
            viewModel.requestSaved(limit: 1)
        } else {
            CoreDataModel.shared.createCoreData(model: model )
            viewModel.requestSaved(limit: 1)
        }
    }
}
