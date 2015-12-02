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


//Bu

-(NSArray *)searchSongs:(enum searchSongs)pref song:(NSString *)song artist:(NSString *)artist {
    if (!artist && !song) {
        return nil;
    }
    
    NSString *searchSongs = API_BASE;
    
    searchSongs = [searchSongs stringByAppendingString:@"track.search"];
    
    //If there is no artist specified, continue
    if (!artist);
    else{
        searchSongs = [searchSongs stringByAppendingString:@"&artist="];
        searchSongs = [searchSongs stringByAppendingString:artist];
    }
    searchSongs = [searchSongs stringByAppendingString:@"&track="];
    searchSongs = [searchSongs stringByAppendingString:song];
    searchSongs = [searchSongs stringByAppendingString:@"&api_key="];
    searchSongs = [searchSongs stringByAppendingString:API_KEY];
    searchSongs = [searchSongs stringByAppendingString:@"&limit=10"];
    searchSongs = [searchSongs stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    searchSongs = [searchSongs stringByAppendingString:@"&format=json"];
    NSLog(@"String is %@", searchSongs);

    //Create Errors
    NSError *error;
    
    NSData *jsonString = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:searchSongs] options:NSDataReadingUncached error:&error]; //Get all raw JSON from the URL and read it into a variable
    
    if (!jsonString) {
        NSLog(@"Error in reading the website --> %@", error);
        if (error.code == 256) {
            NSLog(@"Blank Field!");
            return nil;
        }
    }
    
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonString options:NSJSONReadingMutableContainers error:&error];//Parse all raw JSON into a dictionary
    
    if (!jsonDict) {
        NSLog(@"Error in parsing Data --> %@", error);
    }
    
    switch (pref) {
        case namesOfSongs:{
            NSArray *songNames = [[[[jsonDict valueForKey:@"results"]valueForKey:@"trackmatches"]valueForKey:@"track"]valueForKey:@"name"];
            return songNames;
        }
        case namesOfArtists:{
            NSArray *artistNames = [[[[jsonDict valueForKey:@"results"]valueForKey:@"trackmatches"]valueForKey:@"track"]valueForKey:@"artist"];
            return artistNames;
        }
        default:
            return nil;
    }
}

-(NSArray *)searchAlbums:(enum searchAlbums)pref album:(NSString *)album{
    if (!album){
        return nil;
    }
    NSString *searchAlbums = API_BASE;
    searchAlbums = [searchAlbums stringByAppendingString:@"album.search"];
    searchAlbums = [searchAlbums stringByAppendingString:@"&album="];
    searchAlbums = [searchAlbums stringByAppendingString:album];
    searchAlbums = [searchAlbums stringByAppendingString:@"&api_key="];
    searchAlbums = [searchAlbums stringByAppendingString:API_KEY];
    searchAlbums = [searchAlbums stringByAppendingString:@"&limit=9"];
    searchAlbums = [searchAlbums stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    searchAlbums = [searchAlbums stringByAppendingString:@"&format=json"];
    
    //Create Errors
    NSError *error;
    
    NSData *jsonString = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:searchAlbums] options:NSDataReadingUncached error:&error]; //Get all raw JSON from the URL and read it into a variable
    
    if (!jsonString) {
        NSLog(@"Error in reading the website --> %@", error);
        if (error.code == 256) {
            NSLog(@"Blank Field!");
            return nil;
        }
    }
    
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonString options:NSJSONReadingMutableContainers error:&error]; //Parse all raw JSON into a dictionary
    
    if (!jsonDict) {
        NSLog(@"Error in parsing Data --> %@", error);
    }
    
    switch (pref) {
        case namesOfAlbums:{
            NSArray *albumNames = [[[[jsonDict valueForKey:@"results"]valueForKey:@"albummatches"]valueForKey:@"album"]valueForKey:@"name"];
            return albumNames;
        }
        case namesOfArtists:{
            NSArray *artistNames = [[[[jsonDict valueForKey:@"results"]valueForKey:@"albummatches"]valueForKey:@"album"]valueForKey:@"artist"];
            return artistNames;
        }
        case smallAlbumImages:{
            NSArray *artistNames = [[[[jsonDict valueForKey:@"results"]valueForKey:@"albummatches"]valueForKey:@"album"]valueForKey:@"image"];
            NSMutableArray *images = [NSMutableArray new];
            for (int i = 0; i<artistNames.count; i++) {
                //Get All small images
                NSString *imageURLAsString = [[[artistNames objectAtIndex:i]objectAtIndex:0]valueForKey:@"#text"];
                if ([imageURLAsString  isEqual: @""]) {
                    [images addObject:[UIImage imageNamed:@"PlaceholderSmall"]];
                }else{
                    NSURL *imageURL = [NSURL URLWithString:imageURLAsString];
                    NSData *rawImageData = [[NSData alloc]initWithContentsOfURL:imageURL];
                    UIImage *image = [UIImage imageWithData:rawImageData];
                    [images addObject:image];
                }
            }
            return images;
        }
        case mediumAlbumImages:{
            NSArray *artistNames = [[[[jsonDict valueForKey:@"results"]valueForKey:@"albummatches"]valueForKey:@"album"]valueForKey:@"image"];
            NSMutableArray *images = [NSMutableArray new];
            for (int i = 0; i<artistNames.count; i++) {
                //Get All medium images
                NSString *imageURLAsString = [[[artistNames objectAtIndex:i]objectAtIndex:1]valueForKey:@"#text"];
                if ([imageURLAsString  isEqual: @""]) {
                    [images addObject:[UIImage imageNamed:@"PlaceholderMedium"]];
                }else{
                NSURL *imageURL = [NSURL URLWithString:imageURLAsString];
                NSData *rawImageData = [[NSData alloc]initWithContentsOfURL:imageURL];
                UIImage *image = [UIImage imageWithData:rawImageData];
                [images addObject:image];
                }
            }
            return images;
            
        }
        case largeAlbumImages:{
            NSArray *artistNames = [[[[jsonDict valueForKey:@"results"]valueForKey:@"albummatches"]valueForKey:@"album"]valueForKey:@"image"];
            NSMutableArray *images = [NSMutableArray new];
            for (int i = 0; i<artistNames.count; i++) {
                //Get All Large images
                NSString *imageURLAsString = [[[artistNames objectAtIndex:i]objectAtIndex:2]valueForKey:@"#text"];
                if ([imageURLAsString  isEqual: @""]) {
                    [images addObject:[UIImage imageNamed:@"PlaceholderLarge"]];
                }else{
                    NSURL *imageURL = [NSURL URLWithString:imageURLAsString];
                    NSData *rawImageData = [[NSData alloc]initWithContentsOfURL:imageURL];
                    UIImage *image = [UIImage imageWithData:rawImageData];
                    [images addObject:image];
                }
            }
            return images;
        }
        case XLAlbumImages:{
            NSArray *artistNames = [[[[jsonDict valueForKey:@"results"]valueForKey:@"albummatches"]valueForKey:@"album"]valueForKey:@"image"];
            NSMutableArray *images = [NSMutableArray new];
            for (int i = 0; i<artistNames.count; i++) {
                //Get All XL images
                NSString *imageURLAsString = [[[artistNames objectAtIndex:i]objectAtIndex:3]valueForKey:@"#text"];
                if ([imageURLAsString  isEqual: @""]) {
                    [images addObject:[UIImage imageNamed:@"PlaceholderXL"]];
                }else{
                    NSURL *imageURL = [NSURL URLWithString:imageURLAsString];
                    NSData *rawImageData = [[NSData alloc]initWithContentsOfURL:imageURL];
                    UIImage *image = [UIImage imageWithData:rawImageData];
                    [images addObject:image];
                }
            }
            return images;
        }
        default:
            return nil;
    }
    
}

/*-(NSArray *)albumInfo:(NSString *)artist album:(NSString *)album{
    
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

/*-(NSMutableDictionary *)songInfo:(NSString *)song artist:(NSString *)artist{
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
}*/

@end


