//
//  AddStoreViewModel.swift
//  GroceryStore
//
//  Created by Anna on 4/16/23.
//

import Foundation

class AddStoreViewModel: ObservableObject{ //this is the view model that is the middle man between the model and the userview
    //as a class not struc because we need to use observableobject
    private var firestoreManager: FirestoreManager //connect to the firestoreManager class
    @Published var saved: Bool = false //because its @published, when called it'll generate an event and our UI or view can hook up to the event and display some information, like saving a store just added or below saying can't save store
    @Published var message: String = ""
    
    var name: String = ""
    var address: String = ""
    
    init(){
        firestoreManager = FirestoreManager() //whenever you create an instance of firestoreManager, its already initialized
    }
    
    func save(){
        
        let store = Store(name: name, address: address) //connects to Store file and sends name and address to be put in the object
        firestoreManager.save(store: store){ //save the store we just made above into firestore
            result in
            switch result{
            case .success(let store): //if success get access to store
                DispatchQueue.main.async { //set published properties inside dispatchqueue to set this property on the main thread/queue, not in the background
                    self.saved = store == nil ? false: true //once inside can save store but if nill then not saved
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.message = Constants.Messages.storeSavedFailure //connect to constants file, messages func, and var to let us know it failed
                }
            }
        }
    }
    
}
