//
//  NetworkSessionManager.swift
//  Networking
//
//  Created by Chris on 9/26/14.
//  Copyright (c) 2014 Chris. All rights reserved.
//

import Foundation

public class NetworkSessionManager
{
    static var defaultSession:URLSession
    {
        get
        {
            return URLSession(configuration: URLSessionConfiguration.default );
        }
    }
}

private class SingletonKey
{

}
