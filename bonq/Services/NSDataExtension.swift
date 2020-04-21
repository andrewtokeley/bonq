//
//  NSDataExtension.swift
//  bonq
//
//  Created by Andrew Tokeley on 15/04/20.
//  Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation

extension NSData {
    static func dataWithValue(value: NSValue) -> NSData?
    {
        var size: Int = 0
        let encoding = value.objCType
        NSGetSizeAndAlignment(encoding, &size, nil)
        if let ptr = malloc(size) {
            value.getValue(ptr)
            let data = NSData(bytes: ptr, length: size)
            free(ptr);
            return data
        }
        return nil
    }
}
