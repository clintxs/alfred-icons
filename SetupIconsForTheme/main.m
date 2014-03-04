//
//  main.m
//  SetupIconsForTheme
//
//  Created by Clinton Strong on 3/4/14.
//  Copyright (c) 2014 Clinton Strong. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "AlfredIcons.h"

int main(int argc, const char * argv[])
{
    
    @autoreleasepool {
        
        AlfredIcons *app = [[AlfredIcons alloc] init];
        
        [app swapFileNamesBasedOnCurrentTheme];
        
    }
    return 0;
}
