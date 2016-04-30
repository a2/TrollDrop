//
//  ViewController.m
//  TrollDrop
//
//  Created by Alexsander Akers on 4/30/16.
//  Copyright © 2016 Pandamonia LLC. All rights reserved.
//

#import "ViewController.h"

@interface AirDropNode: NSObject

- (void)startSendWithSessionID:(id)arg1 items:(id)arg2 description:(id)arg3 previewImage:(id)arg4;

@end

@interface AirDropBrowser : NSObject

- (NSArray <AirDropNode *> *)people;
- (void)start;
- (void)stop;

@end

@interface ViewController ()

@property (nonatomic, strong) AirDropBrowser *airDropBrowser;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSURL *sharingURL = [NSURL fileURLWithPath:@"/System/Library/PrivateFrameworks/Sharing.framework"];
    NSBundle *sharingBundle = [NSBundle bundleWithURL:sharingURL];
    if (![sharingBundle load]) return;

    AirDropBrowser *airDropBrowser = [[[sharingBundle classNamed:@"SFAirDropBrowser"] alloc] init];
    [airDropBrowser start];
    self.airDropBrowser = airDropBrowser;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];

    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(trollDrop:) userInfo:nil repeats:YES];
    [self trollDrop:timer];
}

- (void)troll:(AirDropNode *)node
{
    NSURL *URL = [[NSBundle mainBundle] URLForResource:@"trollface" withExtension:@"jpg"];
    [node startSendWithSessionID:nil items:@[URL] description:nil previewImage:nil];
}

- (void)trollDrop:(NSTimer *)timer
{
    for (AirDropNode *node in [self.airDropBrowser people]) {
        [self troll:node];
    }
}

- (void)applicationWillEnterForeground:(NSNotification *)note
{
    [self.airDropBrowser start];
}

- (void)applicationDidEnterBackground:(NSNotification *)note
{
    [self.airDropBrowser stop];
}

@end
