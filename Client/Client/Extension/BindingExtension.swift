//
//  BindingExtension.swift
//  Client
//
//  Created by 김동락 on 2023/07/29.
//

import SwiftUI

extension Binding {
    func toUnwrapped<T>(defaultValue: T) -> Binding<T> where Value == T? {
        Binding<T>(get: { self.wrappedValue ?? defaultValue }, set: { self.wrappedValue = $0 })
    }
    func toUnwrapped<T>() -> Binding<T> where Value == T? {
        Binding<T>(get: { self.wrappedValue! }, set: { self.wrappedValue = $0 })
    }
}
