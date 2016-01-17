//
//  TEngine.h
//  Tomahawk
//
//  Created by Mark Bourke on 28/11/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyAdditions.h"
#import "AFNetworking.h"
#import "AFOAuth2Manager.h"
#import "Private.h"

@interface TEngine : NSObject <NSURLSessionDataDelegate, NSURLSessionDelegate, AFURLRequestSerialization, AFURLResponseSerialization>

typedef enum resolvers {
    RLastFM = 0,
    RSpotify = 1,
    RGPlayMusic = 2,
    RRdio = 3,
    RSoundcloud = 4,
    RDeezer = 5,
    RAppleMusic = 6
} resolvers;

#pragma mark - Search

+(void)searchSongsBySongName:(NSString *)song resolver:(enum resolvers)resolver completion:(void (^)(id response))completion;

+ (void)searchArtistsByArtistName:(NSString *)artist resolver:(enum resolvers)resolver completion:(void (^)(id response))completion;

+ (void)searchAlbumsByAlbumName:(NSString *)album resolver:(enum resolvers)resolver completion:(void (^)(id response))completion;


#pragma mark - Artist

#pragma mark - Authentication

+(void)signIn:(NSString *)username password:(NSString *)password completion:(void (^)(id response))completion;
+(void)authorizeSpotifyWithCode:(NSString *)code completion:(void (^)(id response))completion;
+(void)signOutSpotify;

#pragma mark - Chart

#pragma mark - Event

#pragma mark - Geo

#pragma mark - Group

#pragma mark - Library

#pragma mark - Playlist

#pragma mark - Radio

#pragma mark - Tag

#pragma mark - Track

+(void)getSavedTracksSpotifyWithCompletionBlock:(void (^)(id response))completion;

#pragma mark - User

#pragma mark - Venue

#pragma mark - GitHub

+(void)reportBugWithTitle:(NSString *)title description:(NSString *)body username:(NSString *)assignee password:(NSString *)password completion:(void (^)(id))completion;



@end