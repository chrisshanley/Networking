//
//  NetworkProtocol.swift
//  iOS
//
//  Created by Chris Shanley on 6/3/16.
//  Copyright © 2016 Chirs Shanley. All rights reserved.
//

import Foundation

public enum NetworkConvertableError : Error
{
    case conversionError
}

public protocol NetworkConvertableProtocol
{
    static func fromJSON<T:Any>( _ json:[String:Any], type:T.Type) throws -> T
}
