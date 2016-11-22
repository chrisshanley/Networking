# Networking
Light weight networking library based on NSOperation and the built in URLSession
that knows little about the data its transferring. 

NOTE
This is a work in progress, mainly to alivate larger more oppinionated frameworks. 
It's designed for private API consumption working with auth tokens. 

Some advantages of using operations 
- you can add requerst dependiecies 
- you can cancel all ongoing requests easilly 
- threading is handled for you, we just need to call back on main UI when we need to
- you can limit concurrent requersts going out easily 
- serializing is easy , paralleing is also easy

TODO 
- support for binary data as response type
- add type aliases for JSON conversion 

Example without the ```AbstractNetworkClient```
```
let url       = NSURL(string:"http://someApiHost.com")
let auth      = (type:AuthType.bearer, token:"token-string")
self.factory  = NetworkRequestFactory(baseURL: url, auth:auth)
let headers   = ["x-custom-header":"some-value"]
let endpoint  = "/api/1/path/to/resources"
let req       = self.factory.httpRequest(endpoint, method:method, headers:headers, data:params)
let operation = HTTPOperation(request: req, session: self.session)
operation.completionBlock = {[weak op = operation] in
    if let resp = op?.networkResponse
    {
    // call on main thread and pass data to some parser
    }
}
let queue = OperationQueue()
queue.addOperation(operation)
operation.start()
```

Example with the ```AbstractNetworkClient```
```
// subclass
class LoginNetworkClient : AbstractNetworkClient
{
    func login<T:Any>(_ type:T.Type, email:String, password:String,  closure:@escaping NetworkCompleteClosure<T> )
    {
        let params = (encoding:NetworkParamEncoding.json_ENCODING, params: ["username": email, "password": password] )
        var url = "/api/1/path/to/login"
        super.makeRequest(NetworkHTTPMethod.post, params:params, headers:self.headers, type:type, endpoint: url ) { (obj, status, info) in
            closure(obj, status, info)
        }
    }
}

// usage
typealias JSONDictionary = [String:Any]
self.loginClient = LoginNetworkClient(host: InfoListAccessor.apiHost, session: URLSession.default, auth: nil )        
self.client.login(JSONDictionary.self, email: email, password: pass,  closure: { [unowned self](obj, status, info) in
        if let json = obj
        {
            // handle success
        }
        else
        {
            // handle error
        }
 })

```

