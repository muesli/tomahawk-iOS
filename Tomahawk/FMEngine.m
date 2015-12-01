//
//  FMEngine.m
//  Tomahawk
//
//  Created by Mark Bourke on 28/11/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#define API_BASE @"http://ws.audioscrobbler.com/2.0/?method="
#define API_KEY @"94f82a0fccbf54bee207afdd5d44de97"

#import "FMEngine.h"

@implementation FMEngine

-(instancetype)initWithArtist:(NSString *)artist album:(NSString *)album{
    self = [super init];
    if (!self) {
        return nil;
    }
    //Initialise object and get album info
    //TODO: App crashes when theing is spelt wrong and last.fm autocorrect sucks so fix that
    [self albumInfo:artist album:album];
    return self;
}

-(NSArray *)searchSongs:(NSString *)song artist:(NSString *)artist{
    //Setup API
    NSString *searchSongs = API_BASE;
    searchSongs = [searchSongs stringByAppendingString:@"track.search"];
    //If there is no artist specified, continue
    if (!artist) {}
    else{
        searchSongs = [searchSongs stringByAppendingString:@"&artist="];
        searchSongs = [searchSongs stringByAppendingString:artist];
    }
    searchSongs = [searchSongs stringByAppendingString:@"&track="];
    searchSongs = [searchSongs stringByAppendingString:song];
    searchSongs = [searchSongs stringByAppendingString:@"&api_key="];
    searchSongs = [searchSongs stringByAppendingString:API_KEY];
    searchSongs = [searchSongs stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    searchSongs = [searchSongs stringByAppendingString:@"&format=json"];
   NSLog(@"Address is %@", searchSongs);
    
    //Get all raw JSON from the URL and read it into a variable
    NSData *jsonString = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:searchSongs] options:NSDataReadingUncached error:nil];
    
    //Create Errors
    NSError *error;
    
    //Parse all raw JSON into a dictionary
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonString options:NSJSONReadingMutableContainers error:&error];
    
    //Array of search Results
    NSArray *searchResults = [[[jsonDict valueForKey:@"results"]valueForKey:@"trackmatches"]valueForKey:@"track"];
    
    NSMutableArray *songs = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<30; i++) {
//Fixes crash where   ^^ was greater than the total search results so everything would be nill
        @try {
            NSMutableDictionary *searchInfo = [NSMutableDictionary new];
            NSString *namesOfTracks = [[searchResults objectAtIndex:i] valueForKey:@"name"];
            NSString *artist = [[searchResults objectAtIndex:i] valueForKey:@"artist"];
            
            NSDictionary *songInfo = [self songInfo:namesOfTracks artist:artist];
            NSString *albumName = [songInfo valueForKey:@"albumName"];
            [searchInfo setObject:namesOfTracks forKey:@"trackNames"];
            [searchInfo setObject:artist forKey:@"artist"];
            [songs addObject:searchInfo];
            NSLog(@"Track: %@ Album: %@ Artist: %@",namesOfTracks, albumName, artist);
        }
        @catch (NSException *exception) {
            //break loop when there is no more results
            return songs;
        }
        @finally {
            nil;
        }
        
    }
    return songs;
    
}

-(NSArray *)albumInfo:(NSString *)artist album:(NSString *)album{
    
    //Setup API adress
    NSString *getAlbumInfo = API_BASE;
    getAlbumInfo = [getAlbumInfo stringByAppendingString:@"album.getInfo"];
    getAlbumInfo = [getAlbumInfo stringByAppendingString:@"&artist="];
    getAlbumInfo = [getAlbumInfo stringByAppendingString:artist];
    getAlbumInfo = [getAlbumInfo stringByAppendingString:@"&album="];
    getAlbumInfo = [getAlbumInfo stringByAppendingString:album];
    getAlbumInfo = [getAlbumInfo stringByAppendingString:@"&api_key="];
    getAlbumInfo = [getAlbumInfo stringByAppendingString:API_KEY];
    getAlbumInfo = [getAlbumInfo stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    getAlbumInfo = [getAlbumInfo stringByAppendingString:@"&format=json"];
//    NSLog(@"Get album info Address is %@", getAlbumInfo);

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
}

-(NSMutableDictionary *)songInfo:(NSString *)song artist:(NSString *)artist{
    NSString *songInfo = API_BASE;
    songInfo = [songInfo stringByAppendingString:@"track.getInfo"];
    songInfo = [songInfo stringByAppendingString:@"&artist="];
    songInfo = [songInfo stringByAppendingString:artist];
    songInfo = [songInfo stringByAppendingString:@"&track="];
    songInfo = [songInfo stringByAppendingString:song];
    songInfo = [songInfo stringByAppendingString:@"&api_key="];
    songInfo = [songInfo stringByAppendingString:API_KEY];
    songInfo = [songInfo stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    songInfo = [songInfo stringByAppendingString:@"&format=json"];
    //NSLog(@"Song Info Adress is %@", songInfo);
    
    NSData *jsonString = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:songInfo] options:NSDataReadingUncached error:nil];
    
    NSError *error;
    
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonString options:NSJSONReadingMutableContainers error:&error];
    
    NSMutableDictionary *songInfoDictionary = [NSMutableDictionary new];
    
    NSString *songName = [[jsonDict valueForKey:@"track"]valueForKey:@"name"];
    NSString *albumName = [[[jsonDict valueForKey:@"track"]valueForKey:@"album"]valueForKey:@"title"];
    if (!albumName) {
        albumName = @"Single";
    }
    
    [songInfoDictionary setObject:songName forKey:@"songName"];
    [songInfoDictionary setObject:albumName forKey:@"albumName"];

    return songInfoDictionary;
}

@end


