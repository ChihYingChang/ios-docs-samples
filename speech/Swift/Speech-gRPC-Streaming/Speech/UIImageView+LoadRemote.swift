//
//  UIImageView+LoadRemote.swift
//  Speech
//
//  Created by ChihYing on 4/22/18.
//  Copyright © 2018 Google. All rights reserved.
//

import Foundation

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
