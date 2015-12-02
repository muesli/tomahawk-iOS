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
    namesOfSongs,
    namesOfArtists,
};

enum searchAlbums{
    namesOfAlbums,
    namesOfAlbumArtists,
    smallAlbumImages,
    mediumAlbumImages,
    largeAlbumImages,
    XLAlbumImages,
};

@interface FMEngine : NSObject

#pragma mark - Album

-(NSArray *)searchAlbums:(enum searchAlbums)pref album:(NSString *)album;

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

-(NSArray *)searchSongs:(enum searchSongs)pref song:(NSString *)song artist:(NSString *)artist;

#pragma mark - User

#pragma mark - Venue



@end