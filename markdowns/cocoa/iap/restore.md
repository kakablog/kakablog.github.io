#Restore

There are three product types can be restored: 

* **Non-consumable products:** Such as removing advertisement or advanced features, once user have paid, the application should offer the content for his other iDevices.
* **Auto-renewable subscriptions:** The auto-renew action is handled by the system, if the restore delegate happened, the application should give the access.
* **Free subscriptions:** Only available in Newsstand.

Two delegate should be observered:

```objective-c
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    
}
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    
}
```

The restore action should be motivated by users, because there maybe sign-in progress. Or users may be confused about what they are doing.