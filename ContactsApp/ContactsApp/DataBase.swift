//
//  DataBase.swift
//  ContactsApp
//
//  Created by Ruslan Sharshenov on 14.01.2022.
//

import Foundation


class DataBase{
    
    let defaults = UserDefaults.standard
    static let shared = DataBase()
    
    struct Contact: Codable{
        var name: String
        var number: String
        var fullInfo: String{
            return "\(name) \(number)"
        }
    }
    
    var info: [Contact]{
        get{
            
            if let data = defaults.value(forKey: "info") as? Data{
               return try! PropertyListDecoder().decode([Contact].self, from: data)
            }else{
                return [Contact]()
            }
            
        }
        
        set{
            
           if let data = try? PropertyListEncoder().encode(newValue){
                defaults.set(data, forKey: "info")
            }
            
        }
    }
    
    func saveContact(name: String, number: String){
        let contact = Contact(name: name, number: number)
        info.insert(contact, at: 0)
    }
    
}
