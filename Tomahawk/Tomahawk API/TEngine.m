//
//  TEngine.m
//  Tomahawk
//
//  Created by Mark Bourke on 28/11/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#define ITUNES_BASE @"https://itunes.apple.com/search?"

#define SOUNDCLOUD_BASE @"https://api.soundcloud.com/"
#define SOUNDCLOUD_CLIENT_ID @"3e69fb6130301f668be328e2f8fad38b"

#define SPOTIFY_BASE @"https://api.spotify.com/v1/search?"

#define LASTFM_BASE @"http://ws.audioscrobbler.com/2.0/?method="
#define LASTFM_API_KEY @"94f82a0fccbf54bee207afdd5d44de97"
#define LASTFM_SECRET_KEY @"da737cc6a8f1a6325979e3dba3972c1a"

#define DEEZER_BASE @"http://api.deezer.com/search/"



#import "TEngine.h"

//SPOTIFY ARTIST IMAGES ARE MESSED UP SO objectAtIndex:2 ISNT ALWAYS GETTING 200*200 IMAGES, SOMETIMES ITS GETTING HIHGHER RES AND SOMETIMES ITS GETTING LOWER RES. FIX

//LAST.FM ARTIST FOLLOWERS DONT WORK FOR SOME REASON. FIX

@implementation TEngine{
    BOOL exceptionThrown;
}

#pragma mark - Arguments

-(NSDictionary *)searchSongsiTunes:(NSString *)song{
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
    
    NSMutableArray *images = [NSMutableArray new];
    
    for (int i = 0; i<albumImages.count; i++) {
        //Get All medium images
        NSString *imageURLAsString = [albumImages objectAtIndex:i];
        if ([imageURLAsString  isEqual: @""]) {
            [images addObject:[UIImage imageNamed:@"PlaceholderMedium"]]; //If there is no album image, set it to the placeholder one
        }else{
            NSURL *imageURL = [NSURL URLWithString:imageURLAsString];
            NSData *rawImageData = [[NSData alloc]initWithContentsOfURL:imageURL];
            UIImage *image = [UIImage imageWithData:rawImageData];
            [images addObject:image];
        }
    }
    [myDict setObject:images forKey:@"mediumImages"]; //Returns an array of all medium images. Accessed by: UIImage *image = [[myDict objectForKey:mediumImages]objectAtIndex:index];
    
    return myDict;
}

-(NSDictionary *)searchAlbumsiTunes:(NSString *)album{
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
    
    NSMutableArray *images = [NSMutableArray new];
    
    for (int i = 0; i<albumImages.count; i++) {
        //Get All medium images
        NSString *imageURLAsString = [albumImages objectAtIndex:i];
        if ([imageURLAsString  isEqual: @""]) {
            [images addObject:[UIImage imageNamed:@"PlaceholderMedium"]]; //If there is no album image, set it to the placeholder one
        }else{
            NSURL *imageURL = [NSURL URLWithString:imageURLAsString];
            NSData *rawImageData = [[NSData alloc]initWithContentsOfURL:imageURL];
            UIImage *image = [UIImage imageWithData:rawImageData];
            [images addObject:image];
        }
    }
    [myDict setObject:images forKey:@"mediumImages"]; //Returns an array of all medium images. Accessed by: UIImage *image = [[myDict objectForKey:mediumImages]objectAtIndex:index];
    
    return myDict;
    
}

-(NSDictionary *)searchArtists:(NSString *)artist{
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
    [myDict setObject:artistFollowers forKey:@"artistFollowers"]; //Returns an array of artist follwers wrapped in an NSNumber, acessed by: int follwers = [[[myDict objectForKey:@"artistFollowers"]objectAtIndex:index]intValue];
    
    NSArray *artistImages = [[[[jsonDict valueForKey:@"results"]valueForKey:@"artistmatches"]valueForKey:@"artist"]valueForKey:@"image"];
    
    NSMutableArray *images = [NSMutableArray new];
    for (int i = 0; i<artistImages.count; i++) {
        //Get All medium images
        NSString *imageURLAsString = [[[artistImages objectAtIndex:i]objectAtIndex:2]valueForKey:@"#text"];
        if ([imageURLAsString isEqualToString:@""]) {
            [images addObject:[UIImage imageNamed:@"PlaceholderArtistMedium"]];
        }else{
            NSURL *imageURL = [NSURL URLWithString:imageURLAsString];
            NSData *rawImageData = [[NSData alloc]initWithContentsOfURL:imageURL];
            UIImage *image = [UIImage imageWithData:rawImageData];
            [images addObject:image];
        }
    }
    [myDict setObject:images forKey:@"mediumImages"]; //Returns an array of all medium images. Accessed by: UIImage *image = [[myDict objectForKey:mediumImages]objectAtIndex:index];
    
    
    
    return myDict;
}


-(NSDictionary *)searchPlaylistsSoundcloud:(NSString *)playlist{
    
    //TODO: WHEN PLAYLIST DOESNT HAVE AN IMAGE, CREATE ONE FROM THE TRACKS INSIDE IT. NOTE: WHEN TRACK NUMBER IS LOWER THAN 4, ONLY USE THE FIRST IMAGE AS THE PLAYLIST IMAGE.
    
    
    if (!playlist) {
        return nil;
    }
    
    NSString *searchPlaylists = SOUNDCLOUD_BASE;
    searchPlaylists = [searchPlaylists stringByAppendingString:[NSString stringWithFormat:@"playlists/?q=%@&client_id=%@&limit=4", playlist, SOUNDCLOUD_CLIENT_ID]];
    searchPlaylists = [searchPlaylists stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSDictionary *jsonDict = [self parseURL:searchPlaylists];
    
    if (!jsonDict) {
        return nil;
    }
    
    NSMutableDictionary *myDict = [NSMutableDictionary new];
    
    NSArray *playlistNames = [jsonDict valueForKey:@"title"];
    [myDict setObject:playlistNames forKey:@"playlistNames"]; //Returns array of playlist names which is accessed by: NSString *name = [[myDict objectForKey:@"playlistNames"]objectAtIndex:index];
    
    NSArray *songNumber = [jsonDict valueForKey:@"track_count"];
    [myDict setObject:songNumber forKey:@"songNumber"]; //Returns array of song numbers wrapped in an nsnumber which is accessed by: NSNumber *songNumber = [[myDict objectForKey:@"songNumber"]objectAtIndex:index];
    
    NSArray *playlistImages = [jsonDict valueForKey:@"artwork_url"];
    
    NSMutableArray *images = [NSMutableArray new];
    
    for (int i = 0; i<playlistImages.count; i++) {
        exceptionThrown = FALSE;
        //Get All medium images
        NSString *imageURLAsString = [playlistImages objectAtIndex:i];
        
        //check if there is a playlist image. If not, set it to the placeholder one.
        @try {
            [[playlistImages objectAtIndex:i] isEqualToString:@"<null>"];
        }
        @catch (NSException *exception) {
            [images addObject:[UIImage imageNamed:@"PlaceholderArtistMedium"]];
            exceptionThrown = TRUE;
        }
        @finally {}
        if (exceptionThrown == FALSE) {
            NSURL *imageURL = [NSURL URLWithString:imageURLAsString];
            NSData *rawImageData = [[NSData alloc]initWithContentsOfURL:imageURL];
            UIImage *image = [UIImage imageWithData:rawImageData];
            [images addObject:image];
        }
    }
    [myDict setObject:images forKey:@"mediumImages"]; //Returns an array of all medium images. Accessed by: UIImage *image = [[myDict objectForKey:mediumImages]objectAtIndex:index];
    
    return myDict;
}

-(NSDictionary *)searchArtistsSoundcloud:(NSString *)artist{
    if (!artist) {
        return nil;
    }
    
    NSString *searchArtists = SOUNDCLOUD_BASE;
    searchArtists = [searchArtists stringByAppendingString:[NSString stringWithFormat:@"users/?q=%@&client_id=%@&limit=4", artist, SOUNDCLOUD_CLIENT_ID]];
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
    
    NSMutableArray *images = [NSMutableArray new];
    
    for (int i = 0; i<artistImages.count; i++) {
        exceptionThrown = FALSE;
        //Get All medium images
        NSString *imageURLAsString = [artistImages objectAtIndex:i];
        
        //check if there is no album image. If not, set it to the placeholder one.
        @try {
            [[artistImages objectAtIndex:i] isEqualToString:@"<null>"];
        }
        @catch (NSException *exception) {
            [images addObject:[UIImage imageNamed:@"PlaceholderArtistMedium"]];
            exceptionThrown = TRUE;
        }
        @finally {}
        if (exceptionThrown == FALSE) {
            NSURL *imageURL = [NSURL URLWithString:imageURLAsString];
            NSData *rawImageData = [[NSData alloc]initWithContentsOfURL:imageURL];
            UIImage *image = [UIImage imageWithData:rawImageData];
            [images addObject:image];
        }
    }
    [myDict setObject:images forKey:@"mediumImages"]; //Returns an array of all medium images. Accessed by: UIImage *image = [[myDict objectForKey:mediumImages]objectAtIndex:index];
    
    return myDict;

}

-(NSDictionary *)searchSongsSoundcloud:(NSString *)song{
    if (!song) {
        return nil;
    }
    
    NSString *searchSongs = SOUNDCLOUD_BASE;
    searchSongs = [searchSongs stringByAppendingString:[NSString stringWithFormat:@"tracks/?q=%@&client_id=%@&limit=4", song, SOUNDCLOUD_CLIENT_ID]];
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
    
    for (int i = 0; i<songImages.count; i++) {
        exceptionThrown = FALSE;
        //Get All medium images
        NSString *imageURLAsString = [songImages objectAtIndex:i];
        //check if there is no album image. If not, set it to the placeholder one.
        @try {
            [[songImages objectAtIndex:i] isEqualToString:@"<null>"];
        }
        @catch (NSException *exception) {
            [images addObject:[UIImage imageNamed:@"PlaceholderMedium"]];
            exceptionThrown = TRUE;
        }
        @finally {}
        if (exceptionThrown == FALSE) {
            NSURL *imageURL = [NSURL URLWithString:imageURLAsString];
            NSData *rawImageData = [[NSData alloc]initWithContentsOfURL:imageURL];
            UIImage *image = [UIImage imageWithData:rawImageData];
            [images addObject:image];
        }
    }
    [myDict setObject:images forKey:@"mediumImages"]; //Returns an array of all medium images. Accessed by: UIImage *image = [[myDict objectForKey:mediumImages]objectAtIndex:index];
    
    return myDict;

}


-(NSDictionary *)searchSongsSpotify:(NSString *)song{
    if (!song) {
        return nil;
    }
    
    NSString *searchSongs = SPOTIFY_BASE;
    searchSongs = [searchSongs stringByAppendingString:[NSString stringWithFormat:@"q=%@&type=track&limit=4", song]];
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
        //Get All medium images
        NSString *imageURLAsString = [[[songImages objectAtIndex:i]objectAtIndex:1]valueForKey:@"url"];
        //check if there is no album image. If not, set it to the placeholder one.
        if (!imageURLAsString) {
            [images addObject:[UIImage imageNamed:@"PlaceholderMedium"]];
        }else{
            NSURL *imageURL = [NSURL URLWithString:imageURLAsString];
            NSData *rawImageData = [[NSData alloc]initWithContentsOfURL:imageURL];
            UIImage *image = [UIImage imageWithData:rawImageData];
            [images addObject:image];
        }
    }
    [myDict setObject:images forKey:@"mediumImages"]; //Returns an array of all medium images. Accessed by: UIImage *image = [[myDict objectForKey:mediumImages]objectAtIndex:index];
    return myDict;
}

-(NSDictionary *)searchAlbumsSpotify:(NSString *)album{
    if (!album) {
        return nil;
    }
    
    NSString *searchAlbums = SPOTIFY_BASE;
    searchAlbums = [searchAlbums stringByAppendingString:[NSString stringWithFormat:@"q=%@&type=album&limit=4", album]];
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
        //Get All medium images
        NSString *imageURLAsString = [[[albumImages objectAtIndex:i]objectAtIndex:1]valueForKey:@"url"];
        //check if there is no album image. If not, set it to the placeholder one.
        if (!imageURLAsString) {
            [images addObject:[UIImage imageNamed:@"PlaceholderMedium"]];
        }else{
            NSURL *imageURL = [NSURL URLWithString:imageURLAsString];
            NSData *rawImageData = [[NSData alloc]initWithContentsOfURL:imageURL];
            UIImage *image = [UIImage imageWithData:rawImageData];
            [images addObject:image];
        }
    }
    [myDict setObject:images forKey:@"mediumImages"]; //Returns an array of all medium images. Accessed by: UIImage *image = [[myDict objectForKey:mediumImages]objectAtIndex:index];

    return myDict;
}

-(NSDictionary *)searchArtistsSpotify:(NSString *)artist{
    if (!artist) {
        return nil;
    }
    
    NSString *searchArtists = SPOTIFY_BASE;
    searchArtists = [searchArtists stringByAppendingString:[NSString stringWithFormat:@"q=%@&type=artist&limit=4", artist]];
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
        exceptionThrown = FALSE;
        //Get All medium images
        NSString *imageURLAsString;
        //If there are no artist images, set to placeholder one
        @try {
            imageURLAsString = [[[artistImages objectAtIndex:i]objectAtIndex:2]valueForKey:@"url"];
        }
        @catch (NSException *exception) {
            [images addObject:[UIImage imageNamed:@"PlaceholderArtistMedium"]];
            exceptionThrown = TRUE;
        }
        @finally {
            if (exceptionThrown == FALSE) {
                NSURL *imageURL = [NSURL URLWithString:imageURLAsString];
                NSData *rawImageData = [[NSData alloc]initWithContentsOfURL:imageURL];
                UIImage *image = [UIImage imageWithData:rawImageData];
                [images addObject:image];
            }
        }
    }
    [myDict setObject:images forKey:@"mediumImages"]; //Returns an array of all medium images. Accessed by: UIImage *image = [[myDict objectForKey:mediumImages]objectAtIndex:index];
    
    return myDict;

}

-(NSDictionary *)searchPlaylistsSpotify:(NSString *)playlist{
    if (!playlist) {
        return nil;
    }
    
    NSString *searchPlaylists = SPOTIFY_BASE;
    searchPlaylists = [searchPlaylists stringByAppendingString:[NSString stringWithFormat:@"q=%@&type=playlist&limit=4", playlist]];
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
        //Get All medium images
        NSString *imageURLAsString = [[[playlistImages objectAtIndex:i]objectAtIndex:0]valueForKey:@"url"];
        //check if there is no album image. If not, set it to the placeholder one.
        if (!imageURLAsString) {
            [images addObject:[UIImage imageNamed:@"PlaceholderMedium"]];
        }else{
            NSURL *imageURL = [NSURL URLWithString:imageURLAsString];
            NSData *rawImageData = [[NSData alloc]initWithContentsOfURL:imageURL];
            UIImage *image = [UIImage imageWithData:rawImageData];
            [images addObject:image];
        }
    }
    [myDict setObject:images forKey:@"mediumImages"]; //Returns an array of all medium images. Accessed by: UIImage *image = [[myDict objectForKey:mediumImages]objectAtIndex:index];
    return myDict;
}


-(NSDictionary *)searchSongsDeezer:(NSString *)song{
    if (!song) {
        return nil;
    }
    
    NSString *searchSongs = DEEZER_BASE;
    searchSongs = [searchSongs stringByAppendingString:[NSString stringWithFormat:@"track?q=%@&limit=4", song]];
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
    
    NSMutableArray *images = [NSMutableArray new];
    
    for (int i = 0; i<songImages.count; i++) {
        //Get All medium images
        NSString *imageURLAsString = [songImages objectAtIndex:i];
        //check if there is no album image. If not, set it to the placeholder one.
        if (!imageURLAsString) {
            [images addObject:[UIImage imageNamed:@"PlaceholderMedium"]];
        }else{
            NSURL *imageURL = [NSURL URLWithString:imageURLAsString];
            NSData *rawImageData = [[NSData alloc]initWithContentsOfURL:imageURL];
            UIImage *image = [UIImage imageWithData:rawImageData];
            [images addObject:image];
        }
    }
    [myDict setObject:images forKey:@"mediumImages"]; //Returns an array of all medium images. Accessed by: UIImage *image = [[myDict objectForKey:mediumImages]objectAtIndex:index];
    
    return myDict;
}

-(NSDictionary *)searchAlbumsDeezer:(NSString *)album{
    if (!album) {
        return nil;
    }
    
    NSString *searchAlbums = DEEZER_BASE;
    searchAlbums = [searchAlbums stringByAppendingString:[NSString stringWithFormat:@"album?q=%@&limit=4", album]];
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
    
    NSMutableArray *images = [NSMutableArray new];
    
    for (int i = 0; i<albumImages.count; i++) {
        //Get All medium images
        NSString *imageURLAsString = [albumImages objectAtIndex:i];
        //check if there is no album image. If not, set it to the placeholder one.
        if (!imageURLAsString) {
            [images addObject:[UIImage imageNamed:@"PlaceholderMedium"]];
        }else{
            NSURL *imageURL = [NSURL URLWithString:imageURLAsString];
            NSData *rawImageData = [[NSData alloc]initWithContentsOfURL:imageURL];
            UIImage *image = [UIImage imageWithData:rawImageData];
            [images addObject:image];
        }
    }
    [myDict setObject:images forKey:@"mediumImages"]; //Returns an array of all medium images. Accessed by: UIImage *image = [[myDict objectForKey:mediumImages]objectAtIndex:index];
    
    return myDict;

}

-(NSDictionary *)searchArtistsDeezer:(NSString *)artist{
    if (!artist) {
        return nil;
    }
    
    NSString *searchArtists = DEEZER_BASE;
    searchArtists = [searchArtists stringByAppendingString:[NSString stringWithFormat:@"artist?q=%@&limit=4", artist]];
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
    
    NSMutableArray *images = [NSMutableArray new];
    
    for (int i = 0; i<artistImages.count; i++) {
        //Get All medium images
        NSString *imageURLAsString = [artistImages objectAtIndex:i];
        if (!imageURLAsString) {
            [images addObject:[UIImage imageNamed:@"PlaceholderArtistLarge"]];
        }else{
            NSURL *imageURL = [NSURL URLWithString:imageURLAsString];
            NSData *rawImageData = [[NSData alloc]initWithContentsOfURL:imageURL];
            UIImage *image = [UIImage imageWithData:rawImageData];
            [images addObject:image];
        }
    }
    [myDict setObject:images forKey:@"mediumImages"]; //Returns an array of all medium images. Accessed by: UIImage *image = [[myDict objectForKey:mediumImages]objectAtIndex:index];
    
    return myDict;
  
}

#pragma mark - Authentication

-(void)signIn:(NSString *)username password:(NSString *)password completion:(void (^)(id))completion{
    NSString *api_sig = [NSString stringWithFormat:@"api_key%@methodauth.getMobileSessionpassword%@username%@%@", LASTFM_API_KEY, password, username, LASTFM_SECRET_KEY];//API signature
    
    NSURL *url = [NSURL URLWithString:@"https://ws.audioscrobbler.com/2.0/"];
    NSString *post = [NSString stringWithFormat:@"method=auth.getMobileSession&api_key=94f82a0fccbf54bee207afdd5d44de97&format=json&username=%@&password=%@&api_sig=%@", username, password, [api_sig md5]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:15.0];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[post dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error){
            NSLog(@"error is %@", [error userInfo]);
            completion (error);
        }else{
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
            NSString *sessionKey = [[jsonDict valueForKey:@"session"]valueForKey:@"key"];
        
            if (!sessionKey) {
                NSError *myError = [NSError errorWithDomain:@"com.Tomahawk.ErrorDomain" code:-4 userInfo: @{NSLocalizedDescriptionKey : @"Invalid Username and/or Password"}];
                completion (myError);
            
            }else{
                completion(sessionKey);
            }
        }
        
    }];
    
    [task resume];
}


-(NSDictionary *)parseURL:(NSString *)URLAsString{
    
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

