//
//  AppDelegate.h
//  jocroffline
//
//  Created by reuben on 15/6/13.
//  Copyright (c) 2013 space.works. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import <MobileCoreServices/UTCoreTypes.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    NSString *databaseName;
   NSString *databasePath;
}

@property (strong, nonatomic) UIWindow *window;
@end
