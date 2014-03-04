//
//  AlfredIcons.h
//  SetupIconsForTheme
//
//  Created by Clinton Strong on 3/4/14.
//  Copyright (c) 2014 Clinton Strong. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AlfredIcons : NSObject
{
    NSDictionary *alfredPreferences;
    NSDictionary *appearancePreferences;
}

-(id)init;
-(NSString *)pathToSyncFolder;
-(NSString *)nameOfCurrentTheme;
-(NSDictionary *)appearancePreferences;
-(NSDictionary *)installedThemes;
-(NSDictionary *)currentTheme;
-(NSColor *)backgroundColor;
-(BOOL)isThemeDark;
-(BOOL)isThemeLight;
-(NSArray *)imagesInCurrentDirectory;
-(void)swapFileNamesBasedOnCurrentTheme;

@end
