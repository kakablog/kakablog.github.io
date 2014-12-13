#In App Purchase

[In App Purchase](https://developer.apple.com/in-app-purchase/) is becoming more and more popular. It will bring a better user experience and more revenue especially for games.



##Workflow

**The workflow is as follows:**

###Load In-App Identifiers

The product identifers can be stored in many places, such as in code, some cloud providers and self hosted servers.
 
```objective-c
- (void)getProducts {
    NSSet *set = [NSSet setWithObjects:@"product1.abc.com", @"product2.abc.com", nil];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    request.delegate = self;
    [request start];
}
```

To store the IDs outside the application is recommanded because the application can change wi. 


