//
//  NBPathComponent.swift
//  
//
//  Created by Dan Hart on 3/3/23.
//

import Foundation

public struct NBPathComponent: NBPathComponentable {
    public var id: String
    public var data: AnyHashable
}

public extension NBPathComponent {
    init(id: String, _ data: AnyHashable) {
        self.init(id: id, data: data)
    }
}

extension NBPathComponent: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "NBPathComponent with id: [\(id)] and data: [\(data)]"
    }
}
