//
//  DateExtension.swift
//  bonq
//
//  Created by Andrew Tokeley on 19/04/20.
//  Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

}
