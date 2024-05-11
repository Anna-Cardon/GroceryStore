//
//  View+Extensions.swift
//  GroceryStore
//
//  Created by Anna on 4/16/23.
//

import Foundation
import SwiftUI

extension View {
    func embedInNavigationView() -> some View {
        NavigationView { self }
    }
}
