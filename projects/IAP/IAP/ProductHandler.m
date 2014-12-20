//
//  ProductHandler.m
//  IAP
//
//  Created by LeeQ-work on 12/13/14.
//  Copyright (c) 2014 DrKaKa. All rights reserved.
//

#import "ProductHandler.h"

@interface ProductHandler()
@property (nonatomic, assign) BOOL appleHosted;
@end

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

- (void)appleHostedDownloads:(SKPaymentTransaction *)transaction {
    if (transaction.downloads) {
        //There is content needed to be download.
        [[SKPaymentQueue defaultQueue] startDownloads:transaction.downloads];
    }
}

- (void)finishTransaction {
    SKPaymentQueue *queue = [SKPaymentQueue defaultQueue];
    [queue finishTransaction:queue.transactions[0]];
}

- (void)selfHostedDownloadsWith:(NSString *)downloadID {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration
                                         backgroundSessionConfigurationWithIdentifier:downloadID];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:queue];
    
    NSURL *url = [NSURL URLWithString:@"http://abc.com/abc.zip"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request];
    [task resume];
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
    _appleHosted = false;
    
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                break;
            case SKPaymentTransactionStateFailed:
                break;
            case SKPaymentTransactionStateRestored:
                //The product is previously purchased.
                break;
            case SKPaymentTransactionStatePurchased:
                //Payment will be done.
                if (_appleHosted) {
                    [self appleHostedDownloads:transaction];
                }else {
                    [self selfHostedDownloadsWith:@"downloadID"];
                }

                break;
            case SKPaymentTransactionStateDeferred:
                //Let user back to the application.
                break;
            default:
                break;
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray *)downloads {
    for (SKDownload *download in downloads) {
        NSLog(@"Progress:%f", download.progress);
        
        if (download.downloadState == SKDownloadStateFinished) {
            NSLog(@"Content:%@", download.contentURL.absoluteString);
            
            [self finishTransaction];
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    
}

#pragma mark NSURLSessionDelegate
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    [self finishTransaction];
}

#pragma mark NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    //use this method to get progress.
}


@end
