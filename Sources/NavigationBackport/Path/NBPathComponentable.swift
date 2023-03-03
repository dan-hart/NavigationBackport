//
//  NBPathComponentable.swift
//  NavigationBackpport
//
//  Created by Dan Hart on 3/3/23.
//

import Foundation

public protocol NBPathComponentable: Identifiable, Hashable, Equatable {
    var id: String { get set }
    var data: AnyHashable { get set }
}

