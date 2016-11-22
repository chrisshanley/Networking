//
//  NetworkHTTPData.swift
//  Networking
//
//  Created by Chris on 9/26/14.
//  Copyright (c) 2014 Chris. All rights reserved.
//

import Foundation

public enum NetworkHTTPMethod
{
    case get, put, post, delete
    
    static func toString( _ value:NetworkHTTPMethod )->String
    {
        var stringValue:String
        switch value
        {
            case .get :
                stringValue = "GET"
            case .delete :
                stringValue = "DELETE"
            case .put :
                stringValue = "PUT"
            case .post :
                stringValue = "POST"
        }
        return stringValue
    }
}

public enum NetworkParamEncoding
{
    case formEncoding, jsonEncoding
    
    
}
