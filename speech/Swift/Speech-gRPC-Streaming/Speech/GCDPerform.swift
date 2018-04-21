//
//  GCDPerform.swift
//  SWAG
//
//  Created by ChihYing on 4/14/18.
//  Copyright © 2018 ChihYing. All rights reserved.
//

import Foundation

func performUIUpdatesOnMainThread(_ updates: @escaping () -> Void) {
    
    DispatchQueue.main.async {
        updates()
    }
    
}
