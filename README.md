# Networking
Light weight networking library based on NSOperation and the built in URLSession

NOTE
This is a work in progress, mainly to alivate larger more oppinionated frameworks. 
It's designed for private API consumption working with auth tokens. 

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
    if let data = op?.data
    {
    // call on main thread and pass data to some parser
    }
}
let queue = OperationQueue()
queue.addOperation(operation)
operation.start()
```
