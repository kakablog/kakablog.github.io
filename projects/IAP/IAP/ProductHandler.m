//
//  ProductHandler.m
//  IAP
//
//  Created by LeeQ-work on 12/13/14.
//  Copyright (c) 2014 DrKaKa. All rights reserved.
//

#import "ProductHandler.h"

@implementation ProductHandler

- (void)getProducts {
    NSSet *set = [NSSet setWithObjects:@"product1.abc.com", @"product2.abc.com", nil];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    request.delegate = self;
    [request start];
}

- (void)purchaseProduct:(SKProduct *)product {
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    for (SKProduct *product in response.products) {
        NSString *productID = product.productIdentifier;
        NSLog(@"productID: %@", productID);
    }
}

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
                [queue finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateDeferred:
                //Let user back to the application.
                break;
            default:
                break;
        }
    }
}


@end
