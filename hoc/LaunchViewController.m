//
//  LaunchViewController.m
//
//  Created by Nathaniel Brown on 11/3/14.
//  Copyright (c) 2014 code.org. All rights reserved.
//

#import "LaunchViewController.h"
#import "ContentViewController.h"

@interface LaunchViewController ()

@end

NSUInteger blah = UIInterfaceOrientationMaskAllButUpsideDown;

@implementation LaunchViewController

- (void)viewDidAppear:(BOOL)animated {
  /*
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  ContentViewController *content = [storyboard instantiateViewControllerWithIdentifier:@"ContentViewController"];
  content.view = content.view;
  //  NSString *urlString = @"http://192.168.100.52:3000/hoc/reset";
  NSString *urlString = @"http://localhost:3000/hoc/reset";
  //  NSString *urlString = @"http://studio.code.org/hoc/reset";
  content.path = urlString;
  [self presentViewController:content animated:<#(BOOL)#> completion:<#^(void)completion#>]
  [content loadContent:urlString completion:^{
    blah = UIInterfaceOrientationMaskLandscape;
  }];
  [UIView transitionFromView:self.view toView:content.view duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL completed){
    self.view.window.rootViewController = content;
  }];
   */
}

- (NSUInteger)supportedInterfaceOrientations
{
  return blah;
}

@end
