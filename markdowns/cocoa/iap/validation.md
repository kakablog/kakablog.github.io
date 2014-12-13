#Receipt Validation

Once the payment is done. (Usually the status for `SKPaymentTransaction` is `SKPaymentTransactionStatePurchased`) We should validate the receipt to prevent some crackings.

There are two ways to do the validaton:

###On-device validation
This method is convenient for unlock features and content within the app.


###Server-to-server validation
This method is convenient for server-side configuration.