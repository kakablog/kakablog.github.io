//
//  ProductHandler.h
//  IAP
//
//  Created by LeeQ-work on 12/13/14.
//  Copyright (c) 2014 DrKaKa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface ProductHandler : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>

- (void)getProducts;
- (void)purchaseProduct:(SKProduct *)product;

@end
