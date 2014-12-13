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

To store the IDs outside the application is recommanded because the application can change with user's configuration in iTunes Connect. 

Also it is a good practise to use `SKProductsRequest` to request the products. So the infomation can be changed with the configuration, such as price and descriptions.

Then implenment the delegate to get response:

```objective-c
#pragma mark SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    for (SKProduct *product in response.products) {
        NSString *productID = product.productIdentifier;
        NSLog(@"productID: %@", productID);
    }
}
```

The `SKProductsResponse` takes an array of products, The `SKProduct` is one we need.


###Fetch Product Info

As we already have `SKProduct`, the properties will be reachable. 

###Show In-App UI

Right now we can show the information of the products in a view.

###Make purchase

Before making purchase, we should observe the `SKPaymentQueue`. A good practise is add an observer when application finish launching.

```objective-c
[[SKPaymentQueue defaultQueue] addTransactionObserver:handler];
```

Then users can make the payment:
```objective-c
SKPayment *payment = [SKPayment paymentWithProduct:product];
[[SKPaymentQueue defaultQueue] addPayment:payment];
```

**Note:** The `SKProduct` is returned from `SKProductsResponse`.

###Process Transaction

Thanks to the `StoreKit`, there is no need to do anything until the transaction is observed. 

```objective-c
#pragma mark SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                break;
            case SKPaymentTransactionStateFailed:
                break;
            case SKPaymentTransactionStateRestored:
                //The product is previously bought.
                break;
            case SKPaymentTransactionStatePurchased:
                //Payment will be done.
                break;
            case SKPaymentTransactionStateDeferred:
                //Let user back to the application.
                break;
            default:
                break;
        }
    }
}
```

If need to download content, please check [Content Downloads](https://github.com/kakablog/kakablog.github.io/blob/master/markdowns/cocoa/iap/download.md) for detail.

###Make Asset Available

If the there are something needed to be downloaded, make assets available to the user.

###Finish Transaction

After the payment is successfully handled, we should finish the transaction.

```objective-c
[queue finishTransaction:transaction];
```

