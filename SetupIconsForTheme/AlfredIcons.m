//
//  AlfredIcons.m
//  SetupIconsForTheme
//
//  Created by Clinton Strong on 3/4/14.
//  Copyright (c) 2014 Clinton Strong. All rights reserved.
//

#import "AlfredIcons.h"

@implementation AlfredIcons

-(id)init
{
    if (self = [super init]) {
        NSString *alfredPrefsPlistPath = [@"~/Library/Preferences/com.runningwithcrayons.Alfred-Preferences.plist" stringByExpandingTildeInPath];
        
        NSData *prefsPlistData = [NSData dataWithContentsOfFile:alfredPrefsPlistPath];
        
        alfredPreferences = [NSPropertyListSerialization propertyListWithData:prefsPlistData
                                                                      options:NSPropertyListImmutable
                                                                       format:NULL
                                                                        error:NULL];
    }
    
    return self;
}

-(NSString *)pathToSyncFolder
{
    NSString *path = [alfredPreferences objectForKey:@"syncfolder"];
    
    // Use the default path if the user hasn't enabled syncing
    if (path == nil) {
        path = @"~/Library/Application Support/Alfred 2/";
    }
    
    return [path stringByExpandingTildeInPath];
}

-(NSString *)nameOfCurrentTheme
{
    NSString *name = [alfredPreferences objectForKey:@"appearance.theme"];
    
    // I'm not actually sure if this is set by default, but just in case: set
    // the name to the default theme if it hasn't been set.
    if (name == nil) {
        name = @"alfred.theme.light";
    }
    
    return name;
}

-(NSDictionary *)appearancePreferences
{
    if (appearancePreferences) {
        return appearancePreferences;
    }
    
    NSString *appearancePlistPath = [[self pathToSyncFolder] stringByAppendingString:@"/Alfred.alfredpreferences/preferences/appearance/prefs.plist"];
    
    NSData *appearancePlistData = [NSData dataWithContentsOfFile:appearancePlistPath];
    
    appearancePreferences = [NSPropertyListSerialization propertyListWithData:appearancePlistData
                                                                      options:NSPropertyListImmutable
                                                                       format:NULL
                                                                        error:NULL];
    
    return appearancePreferences;
}

-(NSDictionary *)installedThemes
{
    return [[self appearancePreferences] objectForKey:@"themes"];
}

-(NSDictionary *)currentTheme
{
    return [[self installedThemes] objectForKey:[self nameOfCurrentTheme]];
}

-(NSColor *)backgroundColor
{
    NSColor *color = [NSUnarchiver unarchiveObjectWithData:[[self currentTheme] objectForKey:@"background"]];
    return [color colorUsingColorSpace:[NSColorSpace sRGBColorSpace]];
}

-(BOOL)isThemeDark
{
    NSString *currentTheme = [self nameOfCurrentTheme];
    
    // Alfred doesn't expose color data for built in themes, but we can infer
    // whether they're light or dark based on the name.
    if (![currentTheme hasPrefix:@"alfred.theme.custom"] &&
        [currentTheme rangeOfString:@"dark"].location != NSNotFound)
    {
        return YES;
    } else if (![currentTheme hasPrefix:@"alfred.theme.custom"] || currentTheme == nil) {
        return NO;
    } else {
        return [[self backgroundColor] brightnessComponent] < 0.5;
    }
}

-(BOOL)isThemeLight
{
    return ![self isThemeDark];
}

-(NSArray *)imagesInCurrentDirectory
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *files = [fm contentsOfDirectoryAtPath:[fm currentDirectoryPath] error:nil];
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"self ENDSWITH '.png'"];
    return [files filteredArrayUsingPredicate:filter];
}

-(void)swapFileNamesBasedOnCurrentTheme
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *images = [self imagesInCurrentDirectory];
    NSString *lightPath;
    NSString *darkPath;
    NSString *pathWithoutExtension;
    
    for (NSString *imagePath in images) {
        pathWithoutExtension = [[imagePath componentsSeparatedByString:@"."] objectAtIndex:0];
        // -light.png denotes a light icon, designed for dark themes
        lightPath = [pathWithoutExtension stringByAppendingString:@"-light.png"];
        // -dark.png denotes a dark icon, designed for light themes
        darkPath = [pathWithoutExtension stringByAppendingString:@"-dark.png"];
        
        if ([fm fileExistsAtPath:lightPath] && [self isThemeDark]) {
            [fm moveItemAtPath:imagePath toPath:darkPath error:nil];
            [fm moveItemAtPath:lightPath toPath:imagePath error:nil];
        } else if ([fm fileExistsAtPath:darkPath] && [self isThemeLight]) {
            [fm moveItemAtPath:imagePath toPath:lightPath error:nil];
            [fm moveItemAtPath:darkPath toPath:imagePath error:nil];
        }
    }
}

@end
