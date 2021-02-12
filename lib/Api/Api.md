## API

This document will try to explain how we handle api requests and channels.


### Concepts
List of concepts needed to understand the document:

* **Channel**: the way in which we comunicate with the api, ie: http, blockchain, webhook, etc...

### Main Classes and Utils

We will have a main ApiClient class, from which we will instantiate the client. This class will accept one or more adapters, 
an adapter is a class that extends ApiAdapter and manages a certain channel and implements certain methods.

We should allow each individual request to specify the adapter to use, 
for example we make the request CreateTransacion specify the adapter it wants to use, in the request itself or on request.

#### ApiClient
This is the main class from which we will make requests to api. It will receive a list of adapters, min 1.

Api client will instantiate a set of services, ie: UsersService, AccountsService, TransactionService, etc...

#### ApiAdapter
This is an abstract class from which we will create ApiAdapters for diferent channels.


### Usage Examples


#### ApiClient
```dart
ApiClient client = ApiClient(adapters: [
    HttpAdapter(),
    BlockchainAdapter(),
]);


User user = await client.users.get(':id');

Transaction transaction = Transaction(...);
await client.transactions.create(transaction);
```

#### ApiAdapter example
```dart
class HttpAdapter extends ApiAdapter {
    HttpClient _client = HttpClient();

    HttpAdapter(): super();

    get() {}
    edit() {}
    list() {}
    delete() {}
}
```

