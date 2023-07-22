//
//  Observable.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 20.07.2023.
//

import Foundation

@propertyWrapper
final class Observable<Value> {
    private var onChange: ((Value) -> Void)? = nil

    var wrappedValue: Value {
        didSet {
            onChange?(wrappedValue)
        }
    }

    var projectedValue: Observable<Value> {
        return self
    }

    init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }

    func bind(action: @escaping (Value) -> Void) {
        self.onChange = action
    }
}

@propertyWrapper
final class ObservableWithOldValue<Value> {
    private var willChange: ((Value) -> Void)? = nil
    private var didChange: ((Value) -> Void)? = nil

    var wrappedValue: Value {
        willSet {
            willChange?(wrappedValue)
        }
        didSet {
            didChange?(wrappedValue)
        }
    }

    var projectedValue: ObservableWithOldValue<Value> {
        return self
    }

    init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }

    func bind(willAction: @escaping (Value) -> Void, didAction: @escaping (Value) -> Void) {
        self.willChange = willAction
        self.didChange = didAction
    }
}
