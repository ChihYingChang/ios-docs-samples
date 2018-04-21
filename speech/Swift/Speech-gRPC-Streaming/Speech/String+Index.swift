//
//  String+Index.swift
//  Speech
//
//  Created by ChihYing on 4/20/18.
//  Copyright © 2018 Google. All rights reserved.
//

import Foundation

extension String {
    func indexDistance(of character: Character) -> Int? {
        guard let index = index(of: character) else { return nil }
        return distance(from: startIndex, to: index)
    }
}
