//
//  TEngine.m
//  Tomahawk
//
//  Created by Mark Bourke on 28/11/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "TEngine.h"

#warning SPOTIFY ARTIST IMAGES ARE MESSED UP SO objectAtIndex:2 ISNT ALWAYS GETTING 200*200 IMAGES, SOMETIMES ITS GETTING HIHGHER RES AND SOMETIMES ITS GETTING LOWER RES. FIX


@implementation TEngine

#pragma mark - Search

+ (void)searchSongsBySongName:(NSString *)song resolver:(enum resolvers)resolver completion:(void (^)(id response))completion {
    NSString *baseURL;
    NSString *query;
    NSDictionary *params;
    switch (resolver) {
        case RSpotify:
            baseURL = SPOTIFY_BASE;
            query = @"/v1/search";
            params = @{@"q" : song, @"type" : @"track", @"limit" : @4};
            break;
        case RSoundcloud:
            baseURL = SOUNDCLOUD_BASE;
            query = @"/tracks/";
            params = @{@"q" : song, @"client_id" : SOUNDCLOUD_CLIENT_ID, @"limit" : @4};
            break;
        case RDeezer:
            baseURL = DEEZER_BASE;
            query = @"/search/track";
            params = @{@"q" : song, @"limit" : @4};
            break;
        default:
            break;
    }
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager GET:query parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        switch (resolver) {
            case RSpotify:{
                NSMutableDictionary *myDict = [NSMutableDictionary new];
                
                NSArray *songNames = [[[responseObject valueForKey:@"tracks"]valueForKey:@"items"]valueForKey:@"name"];
                [myDict setObject:songNames forKey:@"songNames"];
                
                NSArray *artistNames = [[[[responseObject valueForKey:@"tracks"]valueForKey:@"items"]valueForKey:@"artists"]valueForKey:@"name"];
                
                NSMutableArray *artists = [NSMutableArray new];
                
                for (int i = 0; i<artistNames.count; i++) {
                    NSString *artist1 = [[artistNames objectAtIndex:i]objectAtIndex:0];
                    @try {
                        NSString *artist2 = [[artistNames objectAtIndex:i]objectAtIndex:1];
                        artist1 = [NSString stringWithFormat:@"%@ (feat. %@)", artist1, artist2];
                    }
                    @catch (NSException *exception) {}
                    @finally {[artists addObject:artist1];}
                }
                [myDict setObject:artists forKey:@"artistNames"];
                
                NSArray *albumNames = [[[[responseObject valueForKey:@"tracks"]valueForKey:@"items"]valueForKey:@"album"]valueForKey:@"name"];
                [myDict setObject:albumNames forKey:@"albumNames"];
                
                NSArray *songImages = [[[[responseObject valueForKey:@"tracks"]valueForKey:@"items"]valueForKey:@"album"]valueForKey:@"images"];
                NSMutableArray *images = [NSMutableArray new];
                for (int i = 0; i<songImages.count; i++) {
                    NSString *imageURLAsString = [[[songImages objectAtIndex:i]objectAtIndex:1]valueForKey:@"url"];
                    [images addObject:imageURLAsString];
                }
                [myDict setObject:images forKey:@"mediumImages"];
                completion (myDict);
            }break;
            case RSoundcloud:{
                NSMutableDictionary *myDict = [NSMutableDictionary new];
                
                NSArray *songNames = [responseObject valueForKey:@"title"];
                [myDict setObject:songNames forKey:@"songNames"];
                
                NSArray *artistNames = [[responseObject valueForKey:@"user"]valueForKey:@"username"];
                [myDict setObject:artistNames forKey:@"artistNames"];
                
                NSArray *songImages = [responseObject valueForKey:@"artwork_url"];
                
                NSMutableArray *images = [NSMutableArray new];
                for (int i =0; i<songImages.count; i++) {
                    if ([[songImages objectAtIndex:i]isKindOfClass:[NSNull class]]) {
                        [images addObject:@""];
                    }else{
                        [images addObject:[songImages objectAtIndex:i]];
                    }
                }
                [myDict setObject:images forKey:@"mediumImages"];
                
                completion (myDict);
            }break;
            case RDeezer: {
                NSMutableDictionary *myDict = [NSMutableDictionary new];
                
                NSArray *songNames = [[responseObject valueForKey:@"data"]valueForKey:@"title"];
                [myDict setObject:songNames forKey:@"songNames"];
                
                NSArray *artistNames = [[[responseObject valueForKey:@"data"]valueForKey:@"artist"]valueForKey:@"name"];
                [myDict setObject:artistNames forKey:@"artistNames"];
                
                NSArray *albumNames = [[[responseObject valueForKey:@"data"]valueForKey:@"album"]valueForKey:@"title"];
                [myDict setObject:albumNames forKey:@"albumNames"];
                
                NSArray *songImages = [[[responseObject valueForKey:@"data"]valueForKey:@"album"]valueForKey:@"cover"];
                [myDict setObject:songImages forKey:@"mediumImages"];
                
                completion (myDict);
            }break;
            default:
                break;
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Failure: %@", error);
        completion (error);
    }];
}
+ (void)searchArtistsByArtistName:(NSString *)artist resolver:(enum resolvers)resolver completion:(void (^)(id response))completion {
    
}

+(NSDictionary *)searchSongsiTunes:(NSString *)song {
    
    if (!song) {
        return nil;
    }
    
    NSString *searchSongs = ITUNES_BASE;
    searchSongs = [searchSongs stringByAppendingString:[NSString stringWithFormat:@"term=%@&entity=musicTrack&limit=4", song]];
    searchSongs = [searchSongs stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    NSDictionary *jsonDict = [self parseURL:searchSongs];
    
    if (!jsonDict) {
        return nil;
    }
    
    NSMutableDictionary *myDict = [NSMutableDictionary new];
    
    NSNumber *resultCount = [jsonDict valueForKey:@"resultCount"];
    [myDict setObject:resultCount forKey:@"resultCount"];
    
    NSArray *songNames = [[jsonDict valueForKey:@"results"]valueForKey:@"trackName"];
    [myDict setObject:songNames forKey:@"songNames"]; //Returns array of song names which is accessed by: NSString *name = [[myDict objectForKey:@"songNames"]objectAtIndex:index];
    
    NSArray *artistNames = [[jsonDict valueForKey:@"results"]valueForKey:@"artistName"];
    [myDict setObject:artistNames forKey:@"artistNames"]; //Returns array of artist names which is accessed by: NSString *name = [[myDict objectForKey:@"artistNames"]objectAtIndex:index];
    NSArray *albumName = [[jsonDict valueForKey:@"results"]valueForKey:@"collectionName"];
    [myDict setObject:albumName forKey:@"albumName"];
    
    NSArray *albumImages = [[jsonDict valueForKey:@"results"]valueForKey:@"artworkUrl100"];
    [myDict setObject:albumImages forKey:@"mediumImages"]; //Returns an array of all medium images. Accessed by: UIImage *image = [[myDict objectForKey:mediumImages]objectAtIndex:index];
    
    return myDict;
}

+(NSDictionary *)searchAlbumsiTunes:(NSString *)album{
    if (!album){
        return nil;
    }

    NSString *searchAlbums = ITUNES_BASE;
    searchAlbums = [searchAlbums stringByAppendingString:[NSString stringWithFormat:@"term=%@&entity=album&limit=4", album]];
    searchAlbums = [searchAlbums stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    NSDictionary *jsonDict = [self parseURL:searchAlbums];
    
    if (!jsonDict) {
        return nil;
    }
    
    NSMutableDictionary *myDict = [NSMutableDictionary new];
    
    NSArray *albumNames = [[jsonDict valueForKey:@"results"]valueForKey:@"collectionName"];
    [myDict setObject:albumNames forKey:@"albumNames"]; //Returns array of album names which is accessed by: NSString *name = [[myDict objectForKey:@"albumNames"]objectAtIndex:index];
    
    NSArray *artistNames = [[jsonDict valueForKey:@"results"]valueForKey:@"artistName"];
    [myDict setObject:artistNames forKey:@"artistNames"]; //Returns array of artist names which is accessed by: NSString *name = [[myDict objectForKey:@"artistNames"]objectAtIndex:index];

    
    NSArray *albumImages = [[jsonDict valueForKey:@"results"]valueForKey:@"artworkUrl100"];
    [myDict setObject:albumImages forKey:@"mediumImages"]; //Returns an array of all medium images. Accessed by: UIImage *image = [[myDict objectForKey:mediumImages]objectAtIndex:index];
    
    return myDict;
    
}

+(NSDictionary *)searchArtists:(NSString *)artist{
    if (!artist) {
        return nil;
    }
    
    NSString *searchArtists = LASTFM_BASE;
    searchArtists = [searchArtists stringByAppendingString:[NSString stringWithFormat:@"artist.search&artist=%@&api_key=%@&limit=4&format=json", artist, LASTFM_API_KEY]];
    searchArtists = [searchArtists stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    
    NSDictionary *jsonDict = [self parseURL:searchArtists];
    
    if (!jsonDict) {
        return nil;
    }
    
    NSMutableDictionary *myDict = [NSMutableDictionary new];
    
    NSArray *artistNames = [[[[jsonDict valueForKey:@"results"]valueForKey:@"artistmatches"]valueForKey:@"artist"]valueForKey:@"name"];
    [myDict setObject:artistNames forKey:@"artistNames"]; //Returns array of artist names which is accessed by: NSString *name = [[myDict objectForKey:@"artistNames"]objectAtIndex:index];
    
    NSArray *artistFollowers = [[[[jsonDict valueForKey:@"results"]valueForKey:@"artistmatches"]valueForKey:@"artist"]valueForKey:@"listeners"];
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    formatter.numberStyle = NSNumberFormatterNoStyle;
    
    NSArray *artistImages = [[[[jsonDict valueForKey:@"results"]valueForKey:@"artistmatches"]valueForKey:@"artist"]valueForKey:@"image"];
    
    NSMutableArray *images = [NSMutableArray new];
    NSMutableArray *followers = [NSMutableArray new];
    for (int i = 0; i<artistImages.count; i++) {
        NSString *imageURLAsString = [[[artistImages objectAtIndex:i]objectAtIndex:2]valueForKey:@"#text"];
        [images addObject:imageURLAsString];
        NSNumber *myNumber = [formatter numberFromString:[artistFollowers objectAtIndex:i]];
        [followers addObject:myNumber];
        
    }
    [myDict setObject:followers forKey:@"artistFollowers"]; //Returns an array of artist follwers wrapped in an NSNumber, acessed by: int follwers = [[[myDict objectForKey:@"artistFollowers"]objectAtIndex:index]intValue];
    [myDict setObject:images forKey:@"mediumImages"]; //Returns an array of all medium images. Accessed by: UIImage *image = [[myDict objectForKey:mediumImages]objectAtIndex:index];
    
    return myDict;
}


+(NSDictionary *)searchPlaylistsSoundcloud:(NSString *)playlist{
    
    
    if (!playlist) {
        return nil;
    }
    
    NSString *searchPlaylists = SOUNDCLOUD_BASE;
    searchPlaylists = [searchPlaylists stringByAppendingString:[NSString stringWithFormat:@"/playlists/?q=%@&client_id=%@&limit=4", playlist, SOUNDCLOUD_CLIENT_ID]];
    searchPlaylists = [searchPlaylists stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

    NSDictionary *jsonDict = [self parseURL:searchPlaylists];
    
    if (!jsonDict) {
        return nil;
    }
    
    NSMutableDictionary *myDict = [NSMutableDictionary new];
    
    
    NSArray *playlistNames = [jsonDict valueForKey:@"title"];
    [myDict setObject:playlistNames forKey:@"playlistNames"]; //Returns array of playlist names which is accessed by: NSString *name = [[myDict objectForKey:@"playlistNames"]objectAtIndex:index];
    
    NSArray *playlistArtists = [[jsonDict valueForKey:@"user"]valueForKey:@"username"];
    [myDict setObject:playlistArtists forKey:@"playlistArtists"]; //Returns array of artist names which is accessed by: NSString *name = [[[myDict objectForKey:@"artistNames"]objectAtIndex:index]objectAtIndex:0];
    
    NSArray *songNumber = [jsonDict valueForKey:@"track_count"];
    [myDict setObject:songNumber forKey:@"trackCount"]; //Returns array of song numbers wrapped in an nsnumber which is accessed by: NSNumber *songNumber = [[myDict objectForKey:@"songNumber"]objectAtIndex:index];
    
    NSArray *playlistImages = [jsonDict valueForKey:@"artwork_url"];
    NSMutableArray *images = [NSMutableArray new];
    for (int i =0; i<playlistImages.count; i++) {
        if ([[playlistImages objectAtIndex:i]isKindOfClass:[NSNull class]]) {
            [images addObject:@""];
        }else{
            [images addObject:[playlistImages objectAtIndex:i]];
        }
    }
    [myDict setObject:images forKey:@"mediumImages"]; //Returns an array of all medium images. Accessed by: UIImage *image = [[myDict objectForKey:mediumImages]objectAtIndex:index];
    
    return myDict;
}

+(NSDictionary *)searchArtistsSoundcloud:(NSString *)artist{
    if (!artist) {
        return nil;
    }
    
    NSString *searchArtists = SOUNDCLOUD_BASE;
    searchArtists = [searchArtists stringByAppendingString:[NSString stringWithFormat:@"/users/?q=%@&client_id=%@&limit=4", artist, SOUNDCLOUD_CLIENT_ID]];
    searchArtists = [searchArtists stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSDictionary *jsonDict = [self parseURL:searchArtists];
    
    if (!jsonDict) {
        return nil;
    }
    
    NSMutableDictionary *myDict = [NSMutableDictionary new];
    
    NSArray *artistFollowers = [jsonDict valueForKey:@"followers_count"];
    
    [myDict setObject:artistFollowers forKey:@"artistFollowers"]; //Returns an array of artist follwers wrapped in an NSNumber, acessed by: int follwers = [[[myDict objectForKey:@"artistFollowers"]objectAtIndex:index]intValue];
    
    NSArray *artistNames = [jsonDict valueForKey:@"username"];
    [myDict setObject:artistNames forKey:@"artistNames"]; //Returns array of artist names which is accessed by: NSString *name = [[myDict objectForKey:@"artistNames"]objectAtIndex:index];
    
    NSArray *artistImages = [jsonDict valueForKey:@"avatar_url"];
    NSLog(@"start");
    NSMutableArray *images = [NSMutableArray new];
    for (int i =0; i<artistImages.count; i++) {
        if ([[artistImages objectAtIndex:i]isKindOfClass:[NSNull class]]) {
            [images addObject:@""];
        }else{
            [images addObject:[artistImages objectAtIndex:i]];
        }
    }
    [myDict setObject:images forKey:@"mediumImages"]; //Returns an array of all medium images. Accessed by: UIImage *image = [[myDict objectForKey:mediumImages]objectAtIndex:index];
    NSLog(@"finish");
    return myDict;

}

+(NSDictionary *)searchSongsSoundcloud:(NSString *)song{
    if (!song) {
        return nil;
    }
    
    NSString *searchSongs = SOUNDCLOUD_BASE;
    searchSongs = [searchSongs stringByAppendingString:[NSString stringWithFormat:@"/tracks/?q=%@&client_id=%@&limit=4", song, SOUNDCLOUD_CLIENT_ID]];
    searchSongs = [searchSongs stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSDictionary *jsonDict = [self parseURL:searchSongs];
    
    if (!jsonDict) {
        return nil;
    }
    
    NSMutableDictionary *myDict = [NSMutableDictionary new];
    
    NSArray *songNames = [jsonDict valueForKey:@"title"];
    [myDict setObject:songNames forKey:@"songNames"]; //Returns array of song names which is accessed by: NSString *name = [[myDict objectForKey:@"songNames"]objectAtIndex:index];
    
    NSArray *artistNames = [[jsonDict valueForKey:@"user"]valueForKey:@"username"];
    [myDict setObject:artistNames forKey:@"artistNames"]; //Returns array of artist names which is accessed by: NSString *name = [[myDict objectForKey:@"artistNames"]objectAtIndex:index];
    
    NSArray *songImages = [jsonDict valueForKey:@"artwork_url"];
    
    NSMutableArray *images = [NSMutableArray new];
    for (int i =0; i<songImages.count; i++) {
        if ([[songImages objectAtIndex:i]isKindOfClass:[NSNull class]]) {
            [images addObject:@""];
        }else{
            [images addObject:[songImages objectAtIndex:i]];
        }
    }
    [myDict setObject:images forKey:@"mediumImages"]; //Returns an array of all medium images. Accessed by: UIImage *image = [[myDict objectForKey:mediumImages]objectAtIndex:index];
    
    return myDict;

}


+(NSDictionary *)searchSongsSpotify:(NSString *)song{
    if (!song) {
        return nil;
    }
    
    NSString *searchSongs = SPOTIFY_BASE;
    searchSongs = [searchSongs stringByAppendingString:[NSString stringWithFormat:@"/v1/search?q=%@&type=track&limit=4", song]];
    searchSongs = [searchSongs stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSDictionary *jsonDict = [self parseURL:searchSongs];
    
    if (!jsonDict) {
        return nil;
    }
    
    NSMutableDictionary *myDict = [NSMutableDictionary new];
    
    NSArray *songNames = [[[jsonDict valueForKey:@"tracks"]valueForKey:@"items"]valueForKey:@"name"];
    [myDict setObject:songNames forKey:@"songNames"]; //Returns array of song names which is accessed by: NSString *name = [[myDict objectForKey:@"songNames"]objectAtIndex:index];
    
    NSArray *artistNames = [[[[jsonDict valueForKey:@"tracks"]valueForKey:@"items"]valueForKey:@"artists"]valueForKey:@"name"];
    
    NSMutableArray *artists = [NSMutableArray new];
    
    for (int i = 0; i<artistNames.count; i++) {
        NSString *artist1 = [[artistNames objectAtIndex:i]objectAtIndex:0];
        @try {
            NSString *artist2 = [[artistNames objectAtIndex:i]objectAtIndex:1];
            artist1 = [NSString stringWithFormat:@"%@ (feat. %@)", artist1, artist2];
        }
        @catch (NSException *exception) {}
        @finally {
            [artists addObject:artist1];
        }
    }
    [myDict setObject:artists forKey:@"artistNames"]; //Returns array of artist names which is accessed by: NSString *name = [[[myDict objectForKey:@"artistNames"]objectAtIndex:index]objectAtIndex:0];
    
    NSArray *albumNames = [[[[jsonDict valueForKey:@"tracks"]valueForKey:@"items"]valueForKey:@"album"]valueForKey:@"name"];
    [myDict setObject:albumNames forKey:@"albumNames"]; //Returns array of album names which is accessed by: NSString *name = [[myDict objectForKey:@"albumNames"]objectAtIndex:index];
    
    NSArray *songImages = [[[[jsonDict valueForKey:@"tracks"]valueForKey:@"items"]valueForKey:@"album"]valueForKey:@"images"];
    NSMutableArray *images = [NSMutableArray new];
    for (int i = 0; i<songImages.count; i++) {
        NSString *imageURLAsString = [[[songImages objectAtIndex:i]objectAtIndex:1]valueForKey:@"url"];
        [images addObject:imageURLAsString];
    }
    [myDict setObject:images forKey:@"mediumImages"]; //Returns an array of all medium images. Accessed by: UIImage *image = [[myDict objectForKey:mediumImages]objectAtIndex:index];
    return myDict;
}

+(NSDictionary *)searchAlbumsSpotify:(NSString *)album{
    if (!album) {
        return nil;
    }
    
    NSString *searchAlbums = SPOTIFY_BASE;
    searchAlbums = [searchAlbums stringByAppendingString:[NSString stringWithFormat:@"/v1/search?q=%@&type=album&limit=4", album]];
    searchAlbums = [searchAlbums stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

    
    NSDictionary *jsonDict = [self parseURL:searchAlbums];
    
    if (!jsonDict) {
        return nil;
    }
    
    NSArray *identifier = [[[jsonDict valueForKey:@"albums"]valueForKey:@"items"]valueForKey:@"id"];
    
    NSMutableArray *artistNames = [NSMutableArray new];
    
    for (int i = 0; i<identifier.count; i++) {
        NSString *albumArtistURL = @"https://api.spotify.com/v1/albums/";
        albumArtistURL = [albumArtistURL stringByAppendingString:[identifier objectAtIndex:i]];
        NSDictionary *albumArtist = [self parseURL:albumArtistURL];
    
        NSString *artists = [[[albumArtist valueForKey:@"artists"]valueForKey:@"name"]objectAtIndex:0];
        [artistNames addObject:artists];
    }
    
    
    NSMutableDictionary *myDict = [NSMutableDictionary new];
    
    [myDict setObject:artistNames forKey:@"artistNames"]; //Returns array of artist names which is accessed by: NSString *name = [[[myDict objectForKey:@"artistNames"]objectAtIndex:index]objectAtIndex:0];
    
    NSArray *albumNames = [[[jsonDict valueForKey:@"albums"]valueForKey:@"items"]valueForKey:@"name"];
    [myDict setObject:albumNames forKey:@"albumNames"]; //Returns array of album names which is accessed by: NSString *name = [[myDict objectForKey:@"albumNames"]objectAtIndex:index];
    
    NSArray *albumImages = [[[jsonDict valueForKey:@"albums"]valueForKey:@"items"]valueForKey:@"images"];
    
    NSMutableArray *images = [NSMutableArray new];
    
    for (int i = 0; i<albumImages.count; i++) {
        NSString *imageURLAsString = [[[albumImages objectAtIndex:i]objectAtIndex:1]valueForKey:@"url"];
        [images addObject:imageURLAsString];
    }
    [myDict setObject:images forKey:@"mediumImages"]; //Returns an array of all medium images. Accessed by: UIImage *image = [[myDict objectForKey:mediumImages]objectAtIndex:index];

    return myDict;
}

+(NSDictionary *)searchArtistsSpotify:(NSString *)artist{
    if (!artist) {
        return nil;
    }
    
    NSString *searchArtists = SPOTIFY_BASE;
    searchArtists = [searchArtists stringByAppendingString:[NSString stringWithFormat:@"/v1/search?q=%@&type=artist&limit=4", artist]];
    searchArtists = [searchArtists stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSDictionary *jsonDict = [self parseURL:searchArtists];
    
    if (!jsonDict) {
        return nil;
    }
    
    NSMutableDictionary *myDict = [NSMutableDictionary new];
    
    NSArray *artistNames = [[[jsonDict valueForKey:@"artists"]valueForKey:@"items"]valueForKey:@"name"];
    [myDict setObject:artistNames forKey:@"artistNames"]; //Returns array of artist names which is accessed by: NSString *name = [[myDict objectForKey:@"artistNames"]objectAtIndex:index];
    
    
    NSArray *artistFollowers = [[[[jsonDict valueForKey:@"artists"]valueForKey:@"items"]valueForKey:@"followers"]valueForKey:@"total"];
    [myDict setObject:artistFollowers forKey:@"artistFollowers"]; //Returns an array of artist follwers wrapped in an NSNumber, acessed by: int follwers = [[[myDict objectForKey:@"artistFollowers"]objectAtIndex:index]intValue];
    NSArray *artistImages = [[[jsonDict valueForKey:@"artists"]valueForKey:@"items"]valueForKey:@"images"];
    
    NSMutableArray *images = [NSMutableArray new];
    
    for (int i = 0; i<artistImages.count; i++) {
        NSString *imageURLAsString;
        @try {
            imageURLAsString = [[[artistImages objectAtIndex:i]objectAtIndex:2]valueForKey:@"url"];
        }
        @catch (NSException *exception) {
            imageURLAsString = @"";
        }
        @finally {
            [images addObject:imageURLAsString];
        }
    }
    [myDict setObject:images forKey:@"mediumImages"]; //Returns an array of all medium images. Accessed by: UIImage *image = [[myDict objectForKey:mediumImages]objectAtIndex:index];
    
    return myDict;

}

+(NSDictionary *)searchPlaylistsSpotify:(NSString *)playlist{
    if (!playlist) {
        return nil;
    }
    
    NSString *searchPlaylists = SPOTIFY_BASE;
    searchPlaylists = [searchPlaylists stringByAppendingString:[NSString stringWithFormat:@"/v1/search?q=%@&type=playlist&limit=4", playlist]];
    searchPlaylists = [searchPlaylists stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    
    NSDictionary *jsonDict = [self parseURL:searchPlaylists];
    
    if (!jsonDict) {
        return nil;
    }
    
    NSMutableDictionary *myDict = [NSMutableDictionary new];
    
    NSArray *playlistNames = [[[jsonDict valueForKey:@"playlists"]valueForKey:@"items"]valueForKey:@"name"];
    [myDict setObject:playlistNames forKey:@"playlistNames"]; //Returns array of song playlist which is accessed by: NSString *name = [[myDict objectForKey:@"playlistNames"]objectAtIndex:index];
    
    NSArray *playlistArtists = [[[[jsonDict valueForKey:@"playlists"]valueForKey:@"items"]valueForKey:@"owner"]valueForKey:@"id"];
    [myDict setObject:playlistArtists forKey:@"playlistArtists"]; //Returns array of artist names which is accessed by: NSString *name = [[[myDict objectForKey:@"artistNames"]objectAtIndex:index]objectAtIndex:0];
    
    NSArray *trackCount = [[[[jsonDict valueForKey:@"playlists"]valueForKey:@"items"]valueForKey:@"tracks"]valueForKey:@"total"];
    [myDict setObject:trackCount forKey:@"trackCount"]; //Returns array of track counts wrapped in an NSNumber, accessed by: NSNumber *trackCount = [[[myDict objectForKey:@"trackCount"]objectAtIndex:index]intValue];
    
    NSArray *playlistImages = [[[jsonDict valueForKey:@"playlists"]valueForKey:@"items"]valueForKey:@"images"];
    
    NSMutableArray *images = [NSMutableArray new];
    
    for (int i = 0; i<playlistImages.count; i++) {
        NSString *imageURLAsString = [[[playlistImages objectAtIndex:i]objectAtIndex:0]valueForKey:@"url"];
        [images addObject:imageURLAsString];
    }
    [myDict setObject:images forKey:@"mediumImages"]; //Returns an array of all medium images. Accessed by: UIImage *image = [[myDict objectForKey:mediumImages]objectAtIndex:index];
    return myDict;
}


+(NSDictionary *)searchSongsDeezer:(NSString *)song{
    if (!song) {
        return nil;
    }
    
    NSString *searchSongs = DEEZER_BASE;
    searchSongs = [searchSongs stringByAppendingString:[NSString stringWithFormat:@"/search/track?q=%@&limit=4", song]];
    searchSongs = [searchSongs stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    

    
    NSDictionary *jsonDict = [self parseURL:searchSongs];
    
    if (!jsonDict) {
        return nil;
    }
    
    NSMutableDictionary *myDict = [NSMutableDictionary new];
    
    NSArray *songNames = [[jsonDict valueForKey:@"data"]valueForKey:@"title"];
    [myDict setObject:songNames forKey:@"songNames"]; //Returns array of song names which is accessed by: NSString *name = [[myDict objectForKey:@"songNames"]objectAtIndex:index];
    
    NSArray *artistNames = [[[jsonDict valueForKey:@"data"]valueForKey:@"artist"]valueForKey:@"name"];
    [myDict setObject:artistNames forKey:@"artistNames"]; //Returns array of artist names which is accessed by: NSString *name = [[myDict objectForKey:@"artistNames"]objectAtIndex:index];
    
    NSArray *albumNames = [[[jsonDict valueForKey:@"data"]valueForKey:@"album"]valueForKey:@"title"];
    [myDict setObject:albumNames forKey:@"albumNames"]; //Returns array of album names which is accessed by: NSString *name = [[myDict objectForKey:@"albumNames"]objectAtIndex:index];
    
    NSArray *songImages = [[[jsonDict valueForKey:@"data"]valueForKey:@"album"]valueForKey:@"cover"];
    [myDict setObject:songImages forKey:@"mediumImages"]; //Returns an array of all medium images. Accessed by: UIImage *image = [[myDict objectForKey:mediumImages]objectAtIndex:index];
    
    return myDict;
}

+(NSDictionary *)searchAlbumsDeezer:(NSString *)album{
    if (!album) {
        return nil;
    }
    
    NSString *searchAlbums = DEEZER_BASE;
    searchAlbums = [searchAlbums stringByAppendingString:[NSString stringWithFormat:@"/search/album?q=%@&limit=4", album]];
    searchAlbums = [searchAlbums stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSDictionary *jsonDict = [self parseURL:searchAlbums];
    
    if (!jsonDict) {
        return nil;
    }
    
    NSMutableDictionary *myDict = [NSMutableDictionary new];
    
    NSArray *albumNames = [[jsonDict valueForKey:@"data"]valueForKey:@"title"];
    [myDict setObject:albumNames forKey:@"albumNames"]; //Returns array of album names which is accessed by: NSString *name = [[myDict objectForKey:@"albumNames"]objectAtIndex:index];
    
    NSArray *artistNames = [[[jsonDict valueForKey:@"data"]valueForKey:@"artist"]valueForKey:@"name"];
    [myDict setObject:artistNames forKey:@"artistNames"]; //Returns array of artist names which is accessed by: NSString *name = [[myDict objectForKey:@"artistNames"]objectAtIndex:index];
    
    NSArray *albumImages = [[jsonDict valueForKey:@"data"]valueForKey:@"cover"];
    [myDict setObject:albumImages forKey:@"mediumImages"]; //Returns an array of all medium images. Accessed by: UIImage *image = [[myDict objectForKey:mediumImages]objectAtIndex:index];
    
    return myDict;

}

+(NSDictionary *)searchArtistsDeezer:(NSString *)artist{
    if (!artist) {
        return nil;
    }
    
    NSString *searchArtists = DEEZER_BASE;
    searchArtists = [searchArtists stringByAppendingString:[NSString stringWithFormat:@"/search/artist?q=%@&limit=4", artist]];
    searchArtists = [searchArtists stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    
    
    NSDictionary *jsonDict = [self parseURL:searchArtists];
    
    if (!jsonDict) {
        return nil;
    }
    
    NSMutableDictionary *myDict = [NSMutableDictionary new];
    
    NSArray *artistNames = [[jsonDict valueForKey:@"data"]valueForKey:@"name"];
    [myDict setObject:artistNames forKey:@"artistNames"]; //Returns array of artist names which is accessed by: NSString *name = [[myDict objectForKey:@"artistNames"]objectAtIndex:index];
    
    NSArray *artistFollowers = [[jsonDict valueForKey:@"data"]valueForKey:@"nb_fan"];
    [myDict setObject:artistFollowers forKey:@"artistFollowers"]; //Returns an array of artist follwers wrapped in an NSNumber, acessed by: int follwers = [[[myDict objectForKey:@"artistFollowers"]objectAtIndex:index]intValue];
    
    NSArray *artistImages = [[jsonDict valueForKey:@"data"]valueForKey:@"picture_medium"];
    [myDict setObject:artistImages forKey:@"mediumImages"]; //Returns an array of all medium images. Accessed by: UIImage *image = [[myDict objectForKey:mediumImages]objectAtIndex:index];
    
    return myDict;
  
}


#pragma mark - Authentication

+(void)signIn:(NSString *)username password:(NSString *)password completion:(void (^)(id))completion{
    
    NSString *api_sig = [NSString stringWithFormat:@"api_key%@methodauth.getMobileSessionpassword%@username%@%@", LASTFM_API_KEY, password, username, LASTFM_SECRET_KEY];
    
    AFHTTPSessionManager *session = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:@"https://ws.audioscrobbler.com/2.0/"] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [session POST:[NSString stringWithFormat:@"?method=auth.getMobileSession&api_key=%@&format=json&username=%@&password=%@&api_sig=%@", LASTFM_API_KEY ,username, password, [api_sig md5]] parameters:nil constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id  responseObject) {
        NSString *sessionKey = [[responseObject valueForKey:@"session"]valueForKey:@"key"];
        NSLog(@"session key is %@", sessionKey);
        completion(sessionKey);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([[[error userInfo]objectForKey:NSLocalizedDescriptionKey] isEqualToString:@"Request failed: forbidden (403)"] ) {
            error = [NSError errorWithDomain:@"com.mourke.Tomahawk.ErrorDomain" code:-4 userInfo: @{NSLocalizedDescriptionKey : @"Invalid Username and/or Password"}];
        }
        completion (error);
    }];
}



+ (void)reportBugWithTitle:(NSString *)title description:(NSString *)body username:(NSString *)assignee password:(NSString *)password completion:(void (^)(id response))completion {


    NSDictionary *params = @{@"assignee" : assignee, @"title" : title, @"body" : body};
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.github.com/repos/mourke/tomahawk-iOS/issues"]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSData *basicAuthCredentials = [[NSString stringWithFormat:@"%@:%@", assignee, password] dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64AuthCredentials = [basicAuthCredentials base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)0];
    configuration.HTTPAdditionalHeaders = @{@"Authorization": [NSString stringWithFormat:@"Basic %@", base64AuthCredentials]};
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];

    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[[params stringify] dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            @try {
                NSDictionary *githubError = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                error = [NSError errorWithDomain:@"com.mourke.Tomahawk.ErrorDomain" code:-4 userInfo: @{NSLocalizedDescriptionKey : [githubError valueForKey:@"message"]}];
                completion (error);
            }
            @catch (NSException *exception) {
                completion (@"Sucess");
            }
            @finally {}
        }else{
          completion (error);
        }
        
    }];
    [task resume];
    
}


+(void)authorizeSpotifyWithCode:(NSString *)code completion:(void (^)(id response))completion {
    NSDictionary *params = @{@"grant_type" : @"authorization_code", @"code" : code, @"redirect_uri" : @"Tomahawk://Spotify"};
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:@"spotify"];
    if (credential.expired == FALSE) {
        NSLog(@"Credential Not Expired: %@", [credential valueForKey:@"expiration"]);
        completion (@"Sucess");
        return;
    }else if (credential != nil && credential.refreshToken != nil){
            NSLog(@"Refreshing Token");
            params = @{@"grant_type" : @"refresh_token", @"refresh_token" : credential.refreshToken};
        }
    AFOAuth2Manager *OAuth2Manager = [[AFOAuth2Manager alloc] initWithBaseURL:[NSURL URLWithString:@"https://accounts.spotify.com"] clientID:SPOTIFY_CLIENT_ID secret:SPOTIFY_CLIENT_SECRET];
    [OAuth2Manager authenticateUsingOAuthWithURLString:@"/api/token" parameters:params success:^(AFOAuthCredential *credential) {
        NSLog(@"Credential is:%@", credential);
        [AFOAuthCredential storeCredential:credential withIdentifier:@"spotify"];
        completion (@"Sucess");
        return;
    } failure:^(NSError *error) {
        NSLog(@"error is %@", error);
        completion (error);
    }];
}

+(void)authorizeDeezerWithCode:(NSString *)code completion:(void (^)(id response))completion {
    
}

+(void)signOutSpotify {
    [AFOAuthCredential deleteCredentialWithIdentifier:@"spotify"];
}

+(void)getSavedTracksSpotifyWithCompletionBlock:(void (^)(id response))completion {
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.spotify.com"]];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:@"spotify"];
    [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
    
    [manager GET:@"/v1/me/tracks" parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        completion (responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Failure: %@", error);
        completion (error);
    }];
}


+(NSDictionary *)parseURL:(NSString *)URLAsString {
    
    NSError *error;
    
    NSData *jsonString = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:URLAsString] options:NSDataReadingMappedIfSafe error:&error]; //Get all raw JSON from the URL and read it into a variable
    
    if (!jsonString) {
        NSLog(@"Error in reading the website --> %@", error);
        if (error.code == 256) {
            //Blank Field
            return nil;
        }
    }
    
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonString options:NSJSONReadingMutableContainers error:&error];//Parse all raw JSON into a dictionary
    
    
    if (!jsonDict) {
        NSLog(@"Error in parsing Data --> %@", error);
        return nil;
    }
    
    return jsonDict;
}

@end


