//
//  StoreItemListViewModel.swift
//  GroceryStore
//
//  Created by Anna on 4/17/23.
//

import Foundation


struct StoreItemViewState {
    var name : String = ""
    var price: String = ""
    var quantity: String = ""
}

struct StoreItemViewModel {
    
    let storeItem : StoreItem //storeItem model object
    
    var storeItemId : String {
        storeItem.id ?? ""
    }
    
    var name: String {
        storeItem.name
    }
    var price: Double {
        storeItem.price
    }
    var quantity: Int {
        storeItem.quantity
    }
}

class StoreItemListViewModel: ObservableObject{
    
    private var firestoreManager: FirestoreManager
    var groceryItemName: String = ""
    @Published var store: StoreViewModel?
    @Published var storeItems: [StoreItemViewModel] = []
    
    //var storeItemVS = StoreItemViewState()
    
    init(){
        firestoreManager = FirestoreManager()
    }
    
    
    func deleteStoreItem(storeId: String, storeItemId : String){
        firestoreManager.deleteStoreItem(storeId: storeId, storeItemId: storeItemId) {
            error in
            if error == nil{
                self.getStoreItemsBy(storeId: storeId)
            }
        }
    }
    
    
    func getStoreItemsBy (storeId: String){
        
        firestoreManager.getStoreItemsBy(storeId: storeId){ result in
            switch result {
            case .success(let items):
                if let items = items {
                    DispatchQueue.main.async {
                        self.storeItems = items.map(StoreItemViewModel.init)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    
    
    func getStoreById(storeId: String){
        
        firestoreManager.getStoreById(storeId: storeId){
            result in
            switch result{
            case .success(let store):
                if let store = store{
                    DispatchQueue.main.async {
                        self.store = StoreViewModel(store: store)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            
            }
        }
    }
    
    func addItemToStore (storeId: String, storeItemVS: StoreItemViewState, completion: @escaping (Error?)-> Void){
        
        let storeItem = StoreItem.from(storeItemVS)
        firestoreManager.updateStore(storeId: storeId, storeItem: storeItem){
            result in
            switch result{
            case .success(_):
                completion(nil)
            case .failure(let error):
                completion(error)
            }
    }
    }
}
