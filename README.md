# Charles Proxy Primer Blog Post

[![Build Status](https://travis-ci.org/rwgrier/unsplashed.png)](https://travis-ci.org/rwgrier/unsplashed)

This project is to be used with my blog post which is a primer on using Charles Proxy. 

- Blog Post: [Charles Proxy Primer](http://ryan.grier.co/post/158520255399/charles-proxy-primer)
- Medium Post: [Charles Proxy Primer](https://medium.com/@rwgrier/charles-proxy-primer-e19804920618)

## How To Run

The project is in Swift 5 and on Xcode 11.x. 

In order to run the sample project, you'll need an Unsplash developer account and an Application ID. You can apply for one here: [Unsplash API](https://unsplash.com/developers). Once you have an Application ID, replace `[YOUR APPLICATION ID HERE]` on the line that says `let clientKey: String = "[YOUR APPLICATION ID HERE]"` in the `PhotoDataSource.swift` class file. 

Without the developer account and Application ID, the code will compile, but when you run the app, you won't see any results. Only an error. 

## Creator

[Ryan Grier](http://github.com/rwgrier)  
[@rwgrier](https://twitter.com/rwgrier)

## License

This project are made available under the MIT license. See the LICENSE file for more info.
