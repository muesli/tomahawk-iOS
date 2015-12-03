//
//  TEngine.h
//  Tomahawk
//
//  Created by Mark Bourke on 28/11/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TEngine : NSObject

#pragma mark - Album

-(NSDictionary *)searchAlbums:(NSString *)album;

#pragma mark - Artist

-(NSDictionary *)searchArtists:(NSString *)artist;

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

-(NSDictionary *)searchSongs:(NSString *)song;

-(NSDictionary *)songInfo:(NSString *)song;

#pragma mark - User

#pragma mark - Venue



@end