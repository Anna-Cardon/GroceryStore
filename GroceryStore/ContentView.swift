//
//  ContentView.swift
//  GroceryStore
//
//  Created by Anna on 4/16/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isPresented : Bool = false
    @ObservedObject private var storeListVM = StoreListViewModel()
    
    var body: some View {
        VStack{
            List(storeListVM.stores, id: \.storeId){ //makes a list using id
                store in
                
                NavigationLink(//click on store cell
                    destination: StoreItemsListView(store: store), //go to another view with the store we clicked
                    label: { //display what we clicked
                    StoreCell(store: store) //pass over a store
                })
                
            }.listStyle(PlainListStyle())
        }
        
        .sheet(isPresented: $isPresented, onDismiss:{ //uses published var
            storeListVM.getAll() //get new stores after adding
        }, content: {
            AddStoreView() //when set to true addstoreview is presented
        })
        .navigationBarItems(trailing: Button(action:{
            isPresented = true
        } , label: {
            Image(systemName: "plus") //makes a plus button
        }))
        .navigationTitle("Grocery App")
        .embedInNavigationView()
        
        .onAppear(perform: {storeListVM.getAll()})
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct StoreCell: View {
    let store: StoreViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 8){ //centers it i think
            Text(store.name)
                .font(.headline)
            Text(store.address)
                .font(.body)
        }
    }
}
