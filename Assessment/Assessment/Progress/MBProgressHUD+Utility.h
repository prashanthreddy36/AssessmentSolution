//
//  MBProgressHUD+Utility.h
//  Assessment
//
//  Created by Prashanth on 01/10/15.
//  Copyright (c) 2015 Prashanth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface MBProgressHUD (Utility)

+ (MB_INSTANCETYPE)showHUDAddedTo:(UIView *)view withText:(NSString*)text animated:(BOOL)animated;

@end
