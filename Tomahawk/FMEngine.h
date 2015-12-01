//
//  FMEngine.h
//  Tomahawk
//
//  Created by Mark Bourke on 28/11/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FMEngine : NSObject

-(instancetype)initWithArtist:(NSString *)artist album:(NSString *)album;

#pragma mark - Album

-(NSArray *)albumInfo:(NSString *)artist album:(NSString *)album;

#pragma mark - Artist

#pragma mark - Authentication

#pragma mark - Chart

#pragma mark - Event

#pragma mark - Geo

#pragma mark - Group

#pragma mark - Library

#pragma mark - Playlist

#pragma mark - Radio

#pragma mark - Tag

#pragma mark - Track

-(NSArray *)searchSongs:(NSString *)songs artist:(NSString *)artist;

-(NSMutableDictionary *)songInfo:(NSString *)song artist:(NSString *)artist;

#pragma mark - User

#pragma mark - Venue



@end