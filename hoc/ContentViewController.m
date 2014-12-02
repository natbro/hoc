//
//  ContentViewController.m
//
//  Copyright (c) 2014 code.org. All rights reserved.
//

#import "ContentViewController.h"
#import "FXReachability.h"

@interface ContentViewController () <UIWebViewDelegate, UIAlertViewDelegate>
@property (nonatomic, strong) UIView *delayView;
@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSString *contentPath;
@property FXReachability *reachability;
@property (nonatomic, strong) UIAlertView *reachabilityAlert;
@end

@implementation ContentViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // load the launch screen NIB, overlay it so we can keep it showing while we load and check network
  // reachability. NOTE: if additional top-level layout constraints are added to the NIB you'll need to
  // manually add them here as well, as otherwise the new view will not adjust to different screens properly
  _delayView = [[[NSBundle mainBundle] loadNibNamed:@"LaunchScreen" owner:self options:nil] lastObject];
  _delayView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:_delayView];
  NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_delayView);
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_delayView]|" options:0 metrics:nil views:viewsDictionary]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_delayView]|" options:0 metrics:nil views:viewsDictionary]];
  _delayView.transform = CGAffineTransformMakeRotation( - M_PI / 2 );
  
  // TODO: bloody iOS 8.2 has changed something about the constraint system and (at least on the simulator) things don't look
  // right as it transitions into landscape mode. works fine on 7.0/7.1/8.0/8.1, just not 8.2
  
  // catch go-to-background to dismiss the modal dialog so exiting actually happens - occaisionally
  // UIAlertViews will block the home-button unless you catch and relay them in this way
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:@"UIApplicationDidEnterBackgroundNotification" object:nil];
  
  _reachabilityAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"kNoNetworkTitle", @"")
                                                  message:NSLocalizedString(@"kNoNetworkMessage", @"")
                                                 delegate:self
                                        cancelButtonTitle:NSLocalizedString(@"kOK", @"")
                                        otherButtonTitles:NSLocalizedString(@"kSettings", @""), nil];
  // for testing the UI, trigger the _reachabilityAlert just to see it
  //[_reachabilityAlert show];
 
  // need to add a notifier to get the initial event - if you call it after calling initWithHost you'll miss it
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkReachabilityUpdate:) name:FXReachabilityStatusDidChangeNotification object:nil];
  
  _reachability = [[FXReachability sharedInstance] initWithHost:@"studio.code.org"];
  
  // modify the user-agent to trigger a different .CSS layout in the server
  // taken from http://stackoverflow.com/a/23654363/452082
  // get the original user-agent of webview
  NSString *oldAgent = [_webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
  NSLog(@"Old user-agent :%@", oldAgent);
  // add custom agent-info to the new agent if not there already - sometimes it may get saved into standardUserDefaults
  if ([oldAgent rangeOfString:@"(HOC-mobile/1.0)"].length == 0) {
    NSString *newAgent = [oldAgent stringByAppendingString:@" (HOC-mobile/1.0)"];
    NSLog(@"New user-agent to trigger better server layout :%@", newAgent);
    
    // register the new agent
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    // this should flush to defaults by itself, but if it doesn't we'll re-apply in the future
  }
  
  _webView.alpha = 0.0;
  _webView.delegate = self;
  //NSString *urlString = @"http://192.168.100.52:3000/hoc/reset";
  //NSString *urlString = @"http://localhost:3000/hoc/reset";
  NSString *urlString = @"http://studio.code.org/hoc/reset";
  [self loadContent:urlString];
}

// the lessons should stick in Landscape orientation at all times
- (NSUInteger)supportedInterfaceOrientations
{
  return UIInterfaceOrientationMaskLandscape;
}


#pragma mark -
#pragma mark Custom Methods

- (void)loadContent:(NSString *)path
{
  _contentPath = path;
  NSURL *contentURL = [NSURL URLWithString:_contentPath];
  NSURLRequest *request = [NSURLRequest requestWithURL:contentURL];
  [_webView loadRequest:request];
}


#pragma mark -
#pragma mark NSNotificationCenter

// notification about network availability from FXReachability cocoapod
- (void)networkReachabilityUpdate:(NSNotification *)notification
{
  FXReachability *reachability = notification.object;
  NSLog(@"new reachability is %d", (int)reachability.status);
  if (reachability.status == FXReachabilityStatusNotReachable) {
    [_reachabilityAlert show];
  }
}

// notification about entering background from the system
- (void)applicationDidEnterBackground:(NSNotification *)notification
{
  if (_reachabilityAlert.isVisible) {
    [_reachabilityAlert dismissWithClickedButtonIndex:0 animated:NO];
  }
}


#pragma mark -
#pragma mark UIAlertViewDelegate Protocol Implementation
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  switch (buttonIndex) {
    case 1:
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=General&path=Network"]];
      // intentional fall-through to 0/default case to exit the app

    case 0:
    default:
    {
      // programmatically press the Home button to close the app
      UIApplication *app = [UIApplication sharedApplication];
      [app performSelector:@selector(suspend)];
      // wait 2 seconds while app is going background
      [NSThread sleepForTimeInterval:2.0];
      // exit app when app is in background
      exit(0);
      break;
    }
  }
}


#pragma mark -
#pragma mark UIWebViewDelegate methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
  return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
  static BOOL _once = true;
  
  if (!_once)
    return;
  
  // once we've begun receiving content, fade out the 'launch screen' and fade in the web content
  _once = false;
  [UIView beginAnimations:@"cachedWebView" context:nil];
  [UIView setAnimationDuration: 0.75f];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
  _delayView.alpha = 0.0f;
  _webView.alpha = 1.0f;
  [UIView commitAnimations];
  return;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
  // TODO: put up _reachabilityAlert and bail due to network down issues?
  NSLog(@"webView:didFailLoadWithError:%@", error);
  return;
}

@end
