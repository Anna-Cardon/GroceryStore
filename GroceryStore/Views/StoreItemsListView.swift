//
//  StoreItemsListView.swift
//  GroceryStore
//
//  Created by Anna on 4/17/23.
//

import SwiftUI

struct StoreItemsListView: View {
    
    var store : StoreViewModel
    @StateObject private var storeItemListVM = StoreItemListViewModel()
    
    @State private var storeItemVS = StoreItemViewState()
    
    private func deleteStoreItem (at indexSet: IndexSet){
        indexSet.forEach({
            index in
            let storeItem = storeItemListVM.storeItems[index]
            storeItemListVM.deleteStoreItem(storeId: store.storeId, storeItemId: storeItem.storeItemId)
        })
    }
    
    var body: some View {
        VStack{
            TextField("Enter item name", text: $storeItemVS.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            TextField("Enter price", text: $storeItemVS.price)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            TextField("Enter quantity", text: $storeItemVS.quantity)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Save"){
                storeItemListVM.addItemToStore(storeId: store.storeId, storeItemVS: storeItemVS){
                    error in
                    
                    if error == nil { //fetch updated list
                        storeItemVS = StoreItemViewState()
                        storeItemListVM.getStoreItemsBy(storeId: store.storeId)
                    }
                }
            }
            
            List{
                ForEach(storeItemListVM.storeItems, id: \.storeItemId){
                    storeItem in
                    Text(storeItem.name)
                }.onDelete(perform: deleteStoreItem)
            }
            
            Spacer()
            
            .onAppear(perform: {
                storeItemListVM.getStoreItemsBy(storeId: store.storeId)
                    })
                }
            }
        }

struct StoreItemsListView_Previews: PreviewProvider {
    static var previews: some View {
        StoreItemsListView(store: StoreViewModel(store: Store(id: "123", name: "heb", address: "123", items: nil)))
    }
}
