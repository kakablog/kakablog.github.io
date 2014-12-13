#Download Content

Sometimes after purchased, user should download the content.

There are two ways to offer the content:

###Hosted In-App Purchase content

It good to just use hosted in-app purchase content:

* Hosted on Apple's server
* Scalable and reliable
* Downloads in background
* Up to 2GB per in-app purchase product

Check whether there is content needed to be downloaded. If there is, `startDownloads`

```objective-c
if (transaction.downloads) {
    //There is content needed to be download.
    [[SKPaymentQueue defaultQueue] startDownloads:transaction.downloads];
}
```

Implement the reletive delegate to watch the download progress:

```objective-c
- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray *)downloads {
    for (SKDownload *download in downloads) {
        NSLog(@"Progress:%f", download.progress);
        
        if (download.downloadState == SKDownloadStateFinished) {
            NSLog(@"Content:%@", download.contentURL.absoluteString);
        }
    }
}
```


###Self-Hosted content

There are some reason not the use Apple's server, such as multi-platform requirement, beyond 2GB size, content will change and so on.

Developer should take care of the content download. The download progress should always run in background and can be restarted after relauncd.

```objective-c
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
```

Observer `NSURLSessionDelegate` to see when to finish

```objective-c
#pragma mark NSURLSessionDelegate
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    [self finishTransaction];
}
```

Observer `NSURLSessionDownloadDelegate` to find out the progress
```objective-c
#pragma mark NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    //use this method to get progress.
}
```

If the network is down while downloading, we should also restart it
```objective-c
- (void)application:(UIApplication *)application
handleEventsForBackgroundURLSession:(NSString *)identifier
  completionHandler:(void (^)())completionHandler {
    
    ProductHandler *handler = [[ProductHandler alloc] init];
    completionHandler = ^{
        [handler finishTransaction];
    };
    [handler selfHostedDownloadsWith:identifier];
}
```


