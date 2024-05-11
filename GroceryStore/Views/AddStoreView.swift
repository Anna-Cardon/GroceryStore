//
//  AddStoreView.swift
//  GroceryStore
//
//  Created by Anna on 4/17/23.
//

import SwiftUI

struct AddStoreView: View {
    @Environment(\.presentationMode) var presentationMode //change and cancel out models
    @StateObject private var addStoreVM = AddStoreViewModel()
    
    var body: some View {
        Form{
            Section{
                TextField("Name", text: $addStoreVM.name)
                TextField("Address", text: $addStoreVM.address)
                HStack{
                    Spacer()
                    Button("Save"){
                        addStoreVM.save()
                    }.onChange(of: addStoreVM.saved, perform: {
                        //make sure it actually saves
                        value in
                               if value{
                        presentationMode.wrappedValue.dismiss()
                               }
                    })
                    
                    Spacer()
                }
                Text(addStoreVM.message)
            }
        }.navigationBarItems(leading: Button(action: {
            presentationMode
                .wrappedValue.dismiss()
        }, label:{
            Image(systemName: "xmark")
        }))
        .navigationTitle("Add New Store")
        .embedInNavigationView()
    }
}

struct AddStoreView_Previews: PreviewProvider {
    static var previews: some View {
        AddStoreView()
    }
}
