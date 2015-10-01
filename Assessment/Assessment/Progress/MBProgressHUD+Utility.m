//
//  MBProgressHUD+Utility.m
//  Assessment
//
//  Created by Prashanth on 01/10/15.
//  Copyright (c) 2015 Prashanth. All rights reserved.
//

#import "MBProgressHUD+Utility.h"

@implementation MBProgressHUD (Utility)

+ (MB_INSTANCETYPE)showHUDAddedTo:(UIView *)view withText:(NSString*)text animated:(BOOL)animated {
    MBProgressHUD* instance = [MBProgressHUD showHUDAddedTo:view animated:animated];
    instance.labelText = text;
    return instance;
}

@end
