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

#pragma mark - Search

-(NSDictionary *)searchAlbumsiTunes:(NSString *)album;
-(NSDictionary *)searchArtistsiTunes:(NSString *)artist;
-(NSDictionary *)searchSongsiTunes:(NSString *)song;

-(NSDictionary *)searchPlaylistsSoundcloud:(NSString *)playlist;
-(NSDictionary *)searchArtistsSoundcloud:(NSString *)artist;
-(NSDictionary *)searchSongsSoundcloud:(NSString *)song;

-(NSDictionary *)searchPlaylistsSpotify:(NSString *)playlist;
-(NSDictionary *)searchArtistsSpotify:(NSString *)artist;
-(NSDictionary *)searchSongsSpotify:(NSString *)song;
-(NSDictionary *)searchAlbumsSpotify:(NSString *)album;


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

#pragma mark - User

#pragma mark - Venue



@end