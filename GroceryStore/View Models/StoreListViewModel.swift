//
//  StoreListViewModel.swift
//  GroceryStore
//
//  Created by Anna on 4/17/23.
//provides data to the view displaying all the stores

import Foundation

class StoreListViewModel: ObservableObject {
    private var firestoreManager: FirestoreManager
    @Published var stores: [StoreViewModel] = []//published makes events happen/refresh
    
    init(){
        firestoreManager = FirestoreManager()
    }
    
    func getAll(){ //func to get the list of stores in the collection
        firestoreManager.getAllStores{ result in //connects to manager and getallstores func
            switch result {
                case .success(let stores):
                    if let stores = stores{
                        DispatchQueue.main.async {
                            self.stores = stores.map(StoreViewModel.init)//makes every store pass through the storeview model vidoe 31
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
}


struct StoreViewModel{
    
    let store : Store
    
    var storeId : String{
        store.id ?? ""
    }
    
    var name : String{
        store.name
    }
    
    var address: String{
        store.address
    }
    
    var items: [String]{
        store.items ?? []
    }
}
