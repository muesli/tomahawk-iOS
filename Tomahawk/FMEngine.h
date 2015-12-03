//
//  FMEngine.h
//  Tomahawk
//
//  Created by Mark Bourke on 28/11/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

enum searchSongs{
    searchSongsNamesOfSongs,
    searchSongsNamesOfArtists,
};

enum searchAlbums{
    searchAlbumsNamesOfAlbums,
    searchAlbumsNamesOfAlbumArtists,
    searchAlbumsSmallAlbumImages,
    searchAlbumsMediumAlbumImages,
    searchAlbumsLargeAlbumImages,
    searchAlbumsXLAlbumImages,
};

enum searchArtists{
    searchArtistNamesOfArtists,
    searchArtistsListeners,
    searchArtists
};

@interface FMEngine : NSObject

#pragma mark - Album

-(nullable NSArray *)searchAlbums:(enum searchAlbums)pref album:(nonnull NSString *)album;

#pragma mark - Artist

-(nullable NSArray *)searchArtists:(enum searchArtists)pref artist:(nonnull NSString *)artist;

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

-(nullable NSArray *)searchSongs:(enum searchSongs)pref song:(nullable NSString *)song artist:(nullable NSString *)artist;

-(nullable NSDictionary *)songInfo:(nonnull NSString *)song artist:(nonnull NSString *)artist;

#pragma mark - User

#pragma mark - Venue



@end