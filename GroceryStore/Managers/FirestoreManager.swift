//
//  FirestoreManager.swift
//  GroceryStore
//
//  Created by Anna on 4/16/23.
//

import Foundation
import FirebaseCore
import FirebaseFirestoreSwift
import FirebaseFirestore

class FirestoreManager{//this is the bit that connects to the firestore
    
    private var db: Firestore
    
    init(){
        db = Firestore.firestore() //connect to firestore
    }
    
    
    func deleteStoreItem(storeId: String, storeItemId: String, completion: @escaping (Error?)->Void){
        
        db.collection("stores")
            .document(storeId)
            .collection("items")
            .document(storeItemId)
            .delete{
                (error) in
                completion(error)
            }
    }
    
    
    func getStoreItemsBy(storeId: String, completion: @escaping (Result<[StoreItem]?, Error>)-> Void){
        
        db.collection("stores")
            .document(storeId)
            .collection("items")
            .getDocuments { (snapshot , error) in
                if let error = error {
                    completion(.failure(error))
                }else{
                    if let snapshot = snapshot {
                        let items: [StoreItem]? = snapshot.documents.compactMap{ doc in
                            var storeItem = try? doc.data(as: StoreItem.self)
                            storeItem?.id = doc.documentID
                            return storeItem
                        }
                        completion(.success(items))
                    }
                }
            }
    }
    
    
    func getStoreById(storeId: String, completion: @escaping (Result<Store?, Error>)-> Void){
        
        let ref = db.collection("stores").document(storeId)//reference to the stores and pass in the storeId
        ref.getDocument {(snapshot, error) in //get whats inside the collection
                if let error = error { //if you cant then error
                    completion(.failure(error))
                }else{
                    if let snapshot = snapshot { //if you can
                        var store: Store? = try? snapshot.data(as: Store.self)
                            if store != nil{
                                store!.id = snapshot.documentID
                                completion(.success(store))
                            }
                        }
                    }
                }
    }
    
    func updateStore(storeId: String, storeItem: StoreItem, completion: @escaping(Result<Store?, Error>)->Void){
        //pass in storeid, pass in values you want ot update, then completion handler to give us the updated store
        do{
            let _ = try db.collection("stores").document(storeId) //reference to the stores and pass in the storeId
                .collection("items").addDocument(from: storeItem)
            
            self.getStoreById(storeId: storeId){
                result in
                switch result {
                case .success(let store):
                    completion(.success(store))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch let error{
            completion(.failure(error))
        }
    }
    
    func getAllStores (completion: @escaping (Result<[Store]?, Error>) -> Void){ //get stores, returns array of stores or an error
        
        db.collection("stores")//connect to firebase collection called stores
            .getDocuments(completion: {(snapshot, error) in //get whats inside the collection
                if let error = error { //if you cant then error
                    completion(.failure(error))
                }else{
                    if let snapshot = snapshot { //if you can
                        let stores: [Store]? = snapshot.documents.compactMap{ //make a var hold the store array
                            doc in
                            var store = try? doc.data(as: Store.self)
                            if store != nil{
                                store!.id = doc.documentID
                            }
                            return store
                        }
                        completion(.success(stores))
                    }
                }
            })
    }
    
    func save(store: Store, completion: @escaping (Result<Store?, Error>) -> Void){
        //func to save store
        do{
            let ref = try db.collection("stores").addDocument(from: store) //try to add new doc if not already there called stores
                ref.getDocument { (snapshot, error) in //get doc and return whats inside
                guard let snapshot = snapshot, error == nil else{ //if it doesn't work say failure and return
                    completion(.failure(error!))
                    return
                }
                //if it does work come down here and store what we want into the doc stores
                    let store = try? snapshot.data(as: Store.self)
                completion(.success(store))//completion handler giving us the saved store
            }
        }catch let error { //another way to say the do didn't work
            completion(.failure(error))
        }
    }
}
