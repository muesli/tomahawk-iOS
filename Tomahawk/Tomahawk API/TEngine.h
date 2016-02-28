//
//  TEngine.h
//  Tomahawk
//
//  Created by Mark Bourke on 28/11/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TEngine : NSObject

typedef NS_ENUM(NSInteger, resolvers) {
    RLastFM = 0,
    RSpotify,
    RGPlayMusic,
    RAppleMusic,
    RSoundcloud,
    ROfficialFM,
    RDeezer,
    RTidal,
    RYouTube,
    RAmazonPM,
    RRhapsody,
    RGenius
};

typedef enum {
    kTracks = 0,
    kArtists,
    kAlbums
} charts;

#define chartsString(enum) [@[@"/chart/0/tracks",@"/chart/0/artists",@"/chart/0/albums"] objectAtIndex:enum]



#pragma mark - Search

+(void)searchSongsBySongName:(NSString *)song resolver:(resolvers)resolver limit:(int)limit page:(int)page completion:(void (^)(id response))completion;

+ (void)searchArtistsByArtistName:(NSString *)artist resolver:(resolvers)resolver limit:(int)limit page:(int)page completion:(void (^)(id response))completion;

+ (void)searchAlbumsByAlbumName:(NSString *)album resolver:(resolvers)resolver limit:(int)limit page:(int)page completion:(void (^)(id response))completion;


#pragma mark - Artist

#pragma mark - Authentication

+(void)authorizeLastFMWithUsername:(NSString *)username password:(NSString *)password completion:(void (^)(id response))completion;
+(void)authorizeSpotifyWithCode:(NSString *)code completion:(void (^)(id response))completion;
+(void)authorizeDeezerWithCode:(NSString *)code completion:(void (^)(id response))completion;
+(void)authorizeSoundcloudWithCode:(NSString *)code completion:(void (^)(id response))completion;

#pragma mark - Chart

+ (void)getChartsWithOption:(charts)chart page:(int)page limit:(int)limit completion:(void (^)(id))completion;

#pragma mark - Event

#pragma mark - Geo

#pragma mark - Group

#pragma mark - Library

#pragma mark - Playlist

#pragma mark - Radio

+(void)getRadioGenresWithCompletionBlock:(void (^)(id response))completion;
+(void)getRadioGenreTracksWithID:(NSNumber *)ID completion:(void (^)(id response))completion;

#pragma mark - Tag

#pragma mark - Track

+(void)getSavedTracksSpotifyWithCompletionBlock:(void (^)(id response))completion;

#pragma mark - User

#pragma mark - Venue

#pragma mark - GitHub

+(void)reportBugWithTitle:(NSString *)title description:(NSString *)body username:(NSString *)assignee password:(NSString *)password completion:(void (^)(id))completion;



@end