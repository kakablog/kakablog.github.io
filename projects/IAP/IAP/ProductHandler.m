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

#pragma mark SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    for (SKProduct *product in response.products) {
        NSString *productID = product.productIdentifier;
        NSLog(@"productID: %@", productID);
    }
}

@end
