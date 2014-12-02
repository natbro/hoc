Hour of Code - iOS
=========

A simple iOS app that displays a `UIWebView` wrapper around [code.org](http://code.org/)'s [Hour of Code](http://studio.code.org/hoc/reset) site.

Although it runs against the current staging branch which is somewhat responsive on mobile devices it is intended to be run against an update (currently in the fork/branch [http://github.com/natbrocode-dot-org](http://github.com/natbro/code-dot-org)) which does additional formatting to make the introduction more compatible with small form-factor devices. It does so in the following ways:

 * hides more headers and footers
 * prevents the resize/rotation logic and the display of the "please rotate your device into landscape" UI and keeps the `UIWebView` always in landscape
 * injects `(HOC-mobile/1.0)` into the browser user-agent for (1) detection on the servers so it can introduce application-specific CSS or logic and (2) detection in the client javascript so it can customize the screen layout to the particular device.
 
The application includes Apple-required Reachability logic and displays a warning when used without network connectivity or if network connectivity is lost.

Installation / Development / Debugging
---
 * requires Cocoapods, `gem install cocoapods` and `pod install` after initial `git clone` (currently only uses [FXReachability](https://github.com/nicklockwood/FXReachability))
 * be sure to only open the project's `hoc.xcworkspace` from XCode and never using `hoc.xcodeproj` - workspaces are how cocoapods function and opening and using the standard project file with XCode will break cocoapods integration.
 * by default and for simplicity (as it is assumed the tweaked branch will merge into production) the app is configured to connect to [http://studio.code.org/hoc/reset](http://studio.code.org/hoc/reset). For testing/debugging/building you should alter `ContentViewController.m` to point to your [http://localhost:3000/hoc/reset](http://localhost:3000/hoc/reset) installation of the branch.
 * an additional useful way to debug CSS/JS/EJS/etc changes is to use Google Chrome and put the Developer Console into "device mode" to simulate various sizes of iOS devices. When doing this it's also useful to add `(HOC-mobile/1.0)` to the user-agent string and flip to a landscape orientation.
 
Questions
---
 * Email [natbro](mailto:natbro@gmail.com), Twitter [@natbro](http://twitter.com/natbro)