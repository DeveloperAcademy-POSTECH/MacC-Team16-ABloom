//
//  Ex+Sequence.swift
//  ABloom
//
//  Created by 정승균 on 10/30/23.
//

import Foundation

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
