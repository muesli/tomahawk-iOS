//
//  TEngine.m
//  Tomahawk
//
//  Created by Mark Bourke on 28/11/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#define ITUNES_BASE @"https://itunes.apple.com/search?"
#define API_KEY @"94f82a0fccbf54bee207afdd5d44de97"

#define SOUNDCLOUD_CLIENT_ID @"3e69fb6130301f668be328e2f8fad38b"
#define SOUNDCLOUD_BASE @"https://api.soundcloud.com/"

#import "TEngine.h"

@implementation TEngine{
    BOOL exceptionThrown;
}

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

/*-(NSDictionary *)songInfo:(NSString *)song{
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
}*/

/*-(NSArray *)albumInfo:(NSString *)artist album:(NSString *)album{
    
    //Setup API adress
    NSString *getAlbumInfo = ITUNES_BASE;
    getAlbumInfo = [getAlbumInfo stringByAppendingString:@"album.getInfo"];
    getAlbumInfo = [getAlbumInfo stringByAppendingString:@"&artist="];
    getAlbumInfo = [getAlbumInfo stringByAppendingString:artist];
    getAlbumInfo = [getAlbumInfo stringByAppendingString:@"&album="];
    getAlbumInfo = [getAlbumInfo stringByAppendingString:album];
    getAlbumInfo = [getAlbumInfo stringByAppendingString:@"&api_key="];
    getAlbumInfo = [getAlbumInfo stringByAppendingString:API_KEY];
    getAlbumInfo = [getAlbumInfo stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    getAlbumInfo = [getAlbumInfo stringByAppendingString:@"&format=json"];
    //NSLog(@"Get album info Address is %@", getAlbumInfo);

    //Get all rawJSON and read it into a variable
    NSData *jsonString = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:getAlbumInfo] options:NSDataReadingUncached error:nil];

    //Create Error Messages
    NSError *error;
    
    //Parse the rawJSON into an NSDictionary
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonString options:0 error:&error];

    //Determin the size of the album
    NSArray *tracks = [[[jsonDict valueForKey:@"album"]valueForKey:@"tracks"]valueForKey:@"track"];
    
    //Create an array to hold the dictionary so we can acess individual songs in the album to get the info
    NSMutableArray *albumInfoArray = [NSMutableArray new];
    //Create dictionary to hold all info
    NSMutableDictionary *albumInfo;
    
    //Loop through the tracks and assign all of them properties
    for (int i = 0; i<tracks.count; i++){
        albumInfo = [NSMutableDictionary new];
        NSString *nameOfTrack = [[tracks objectAtIndex:i] valueForKey:@"name"];
        NSString *artist = [[jsonDict valueForKey:@"album"]valueForKey:@"artist"];
        NSNumber *listeners = [[jsonDict valueForKey:@"album"]valueForKey:@"listeners"];
        [albumInfo setObject:nameOfTrack forKey:@"trackName"];
        [albumInfo setObject:artist forKey:@"artist"];
        [albumInfo setObject:listeners forKey:@"listeners"];
        [albumInfoArray addObject:albumInfo];
    }
    
    
    //Returns array of tracks so we can get the number of tracks if we want to later
    albumInfo = [NSMutableDictionary new];
    [albumInfo setObject:tracks forKey:@"tracks"];
    [albumInfoArray addObject:albumInfo];

    //Returns array of image sizes
    albumInfo = [NSMutableDictionary new];
    NSArray *images = [[jsonDict valueForKey:@"album"]valueForKey:@"image"];
    [albumInfo setObject:images forKey:@"images"];
    [albumInfoArray addObject:albumInfo];
    
    return albumInfoArray;
}*/

//-(NSDictionary *)songInfo:(NSString *)song artist:(NSString *)artist{
//    NSString *songInfo = ITUNES_BASE;
//    songInfo = [songInfo stringByAppendingString:[NSString stringWithFormat:@"track.getInfo&artist=%@&track=%@&api_key=%@&limit=10&format=json&autocorrect=1", artist, song, API_KEY]];
//    
//    songInfo = [songInfo stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
//    
//    NSDictionary *jsonDict = [self parseURL:songInfo];
//    
//    if (!jsonDict) {
//        return nil;
//    }
//    
//    NSMutableDictionary *myDict = [NSMutableDictionary new];
//    
//    NSString *songName = [[jsonDict valueForKey:@"track"]valueForKey:@"name"];
//    [myDict setObject:songName forKey:@"songName"]; //Returns Song Name
//
//    NSString *songArtist = [[[jsonDict valueForKey:@"track"]valueForKey:@"artist"]valueForKey:@"name"];
//    [myDict setObject:songArtist forKey:@"songArtist"]; //Returns Song Artist
//
//    NSArray *tags = @[[[[jsonDict valueForKey:@"track"]valueForKey:@"toptags"]valueForKey:@"tag"]];
//    [myDict setObject:tags forKey:@"tags"]; //Returns array of tags. Access name property by: [[[myDictionary objectForKey:tags]objectAtIndex:index]valueForKey:@"name"];
//
//    NSString *albumArtist = [[[jsonDict valueForKey:@"track"]valueForKey:@"album"]valueForKey:@"artist"];
//    [myDict setObject:albumArtist forKey:@"albumArtist"]; //Returns Album artist. Some songs do not have albums so remember to check if result is nil when implementing or a crash will occur
//    
//    NSString *albumTitle = [[[jsonDict valueForKey:@"track"]valueForKey:@"album"]valueForKey:@"title"];
//    [myDict setObject:albumTitle forKey:@"albumTitle"]; //Returns Album title. Some songs do not have albums so remember to check if result is nil when implementing or a crash will occur
//
//    NSNumber *listenerCount = [[jsonDict valueForKey:@"track"]valueForKey:@"listeners"];
//    [myDict setObject:listenerCount forKey:@"listenerCount"];//Returns the number of people who listened to the track. Remember to unwrap the NSNumber when implementing if needs be
//
//    NSNumber *playCount = [[jsonDict valueForKey:@"track"]valueForKey:@"playcount"];
//    [myDict setObject:playCount forKey:@"playCount"];//Returns the number of times the track has been played. Remember to unwrap the NSNumber when implementing if needs be
//    
//    NSArray *albumImages = [[[jsonDict valueForKey:@"track"]valueForKey:@"album"]valueForKey:@"image"];
//    NSMutableArray *tempArray = [NSMutableArray new];
//    if (albumImages) {
//        for (int i = 0; i<albumImages.count; i++) {
//            NSString *imageURLAsString = [[albumImages objectAtIndex:i]valueForKey:@"#text"];
//            NSURL *imageURL = [NSURL URLWithString:imageURLAsString];
//            NSData *rawImageData = [[NSData alloc]initWithContentsOfURL:imageURL];
//            UIImage *image = [UIImage imageWithData:rawImageData];
//            [tempArray addObject:image];
//        }
//        [myDict setObject:[tempArray objectAtIndex:0] forKey:@"smallAlbumImage"];//Returns small UIImage of album art if any. Some songs do not have albums so remember to check if result is nil when implementing or a crash will occur
//        [myDict setObject:[tempArray objectAtIndex:1] forKey:@"mediumAlbumImage"];//Returns medium UIImage of album art if any. Some songs do not have albums so remember to check if result is nil when implementing or a crash will occur
//        [myDict setObject:[tempArray objectAtIndex:2] forKey:@"largeAlbumImage"];//Returns large UIImage of album art if any. Some songs do not have albums so remember to check if result is nil when implementing or a crash will occur
//        [myDict setObject:[tempArray objectAtIndex:3] forKey:@"XLAlbumImage"];//Returns XL UIImage of album art if any. Some songs do not have albums so remember to check if result is nil when implementing or a crash will occur
//    }
//    return myDict;
//
//}
//

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
        NSLog(@"image url is %@", imageURLAsString);
        
        //check if there is no album image. If not, set it to the placeholder one.
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
    
    NSArray *artistNames = [jsonDict valueForKey:@"username"];
    [myDict setObject:artistNames forKey:@"artistNames"]; //Returns array of artist names which is accessed by: NSString *name = [[myDict objectForKey:@"artistNames"]objectAtIndex:index];
    
    NSArray *artistImages = [jsonDict valueForKey:@"avatar_url"];
    
    NSMutableArray *images = [NSMutableArray new];
    
    for (int i = 0; i<artistImages.count; i++) {
        exceptionThrown = FALSE;
        //Get All medium images
        NSString *imageURLAsString = [artistImages objectAtIndex:i];
        NSLog(@"image url is %@", imageURLAsString);
        
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
        NSLog(@"image url is %@", imageURLAsString);
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

-(NSDictionary *)parseURL:(NSString *)URLAsString{
    
    //TAKES 5 SECONDS TO GET FROM TOP TO BOTTOM. FIX
    
    NSLog(@"string is %@", URLAsString);
    
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


