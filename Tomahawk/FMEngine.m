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

//CRASHES WHEN YOU SPELL SEARCH WRONG

@implementation FMEngine

-(NSArray *)searchSongs:(enum searchSongs)pref song:(NSString *)song artist:(NSString *)artist {
    if (!artist && !song) {
        return nil;
    }
    
    NSString *searchSongs = API_BASE;
    searchSongs = [searchSongs stringByAppendingString:@"track.search"];
    
    //If there is no artist specified, continue
    if (!artist);
    else{
        searchSongs = [searchSongs stringByAppendingString:[NSString stringWithFormat:@"%@=%@", @"&artist", artist]];
    }
    
    searchSongs = [searchSongs stringByAppendingString:[NSString stringWithFormat:@"&track=%@&api_key=%@&limit=10&format=json", song, API_KEY]];
    searchSongs = [searchSongs stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSDictionary *jsonDict = [self parseURL:searchSongs];
    
    if (!jsonDict) {
        return nil;
    }
    
    switch (pref) {
        case searchSongsNamesOfSongs:{
            NSArray *songNames = [[[[jsonDict valueForKey:@"results"]valueForKey:@"trackmatches"]valueForKey:@"track"]valueForKey:@"name"];
            return songNames;
        }
        case searchSongsNamesOfArtists:{
            NSArray *artistNames = [[[[jsonDict valueForKey:@"results"]valueForKey:@"trackmatches"]valueForKey:@"track"]valueForKey:@"artist"];
            return artistNames;
        }
        default:
            return nil;
    }
}

-(nullable NSArray *)searchAlbums:(enum searchAlbums)pref album:(nonnull NSString *)album{
    if (!album){
        return nil;
    }
    
    
    NSString *searchAlbums = [[NSString alloc]init];
    searchAlbums = [searchAlbums stringByAppendingString:[NSString stringWithFormat:@"%@album.search&album=%@&api_key=%@&limit=10&format=json", API_BASE, album, API_KEY]];
    searchAlbums = [searchAlbums stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSDictionary *jsonDict = [self parseURL:searchAlbums];
    
    if (!jsonDict) {
        return nil;
    }
    
    switch (pref) {
        case searchAlbumsNamesOfAlbums:{
            NSArray *albumNames = [[[[jsonDict valueForKey:@"results"]valueForKey:@"albummatches"]valueForKey:@"album"]valueForKey:@"name"];
            return albumNames;
        }
        case searchAlbumsNamesOfAlbumArtists:{
            NSArray *artistNames = [[[[jsonDict valueForKey:@"results"]valueForKey:@"albummatches"]valueForKey:@"album"]valueForKey:@"artist"];
            return artistNames;
        }
        case searchAlbumsSmallAlbumImages:{
            NSArray *albumImages = [[[[jsonDict valueForKey:@"results"]valueForKey:@"albummatches"]valueForKey:@"album"]valueForKey:@"image"];
            NSMutableArray *images = [NSMutableArray new];
            for (int i = 0; i<albumImages.count; i++) {
                //Get All small images
                NSString *imageURLAsString = [[[albumImages objectAtIndex:i]objectAtIndex:0]valueForKey:@"#text"];
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
        case searchAlbumsMediumAlbumImages:{
            NSArray *albumImages = [[[[jsonDict valueForKey:@"results"]valueForKey:@"albummatches"]valueForKey:@"album"]valueForKey:@"image"];
            NSMutableArray *images = [NSMutableArray new];
            for (int i = 0; i<albumImages.count; i++) {
                //Get All medium images
                NSString *imageURLAsString = [[[albumImages objectAtIndex:i]objectAtIndex:1]valueForKey:@"#text"];
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
        case searchAlbumsLargeAlbumImages:{
            NSArray *albumImages = [[[[jsonDict valueForKey:@"results"]valueForKey:@"albummatches"]valueForKey:@"album"]valueForKey:@"image"];
            NSMutableArray *images = [NSMutableArray new];
            for (int i = 0; i<albumImages.count; i++) {
                //Get All Large images
                NSString *imageURLAsString = [[[albumImages objectAtIndex:i]objectAtIndex:2]valueForKey:@"#text"];
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
        case searchAlbumsXLAlbumImages:{
            NSArray *albumImages = [[[[jsonDict valueForKey:@"results"]valueForKey:@"albummatches"]valueForKey:@"album"]valueForKey:@"image"];
            NSMutableArray *images = [NSMutableArray new];
            for (int i = 0; i<albumImages.count; i++) {
                //Get All XL images
                NSString *imageURLAsString = [[[albumImages objectAtIndex:i]objectAtIndex:3]valueForKey:@"#text"];
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

-(NSDictionary *)songInfo:(nonnull NSString *)song artist:(nonnull NSString *)artist{
    NSString *songInfo = API_BASE;
    songInfo = [songInfo stringByAppendingString:[NSString stringWithFormat:@"track.getInfo&artist=%@&track=%@&api_key=%@&limit=10&format=json&autocorrect=1", artist, song, API_KEY]];
    
    songInfo = [songInfo stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSDictionary *jsonDict = [self parseURL:songInfo];
    
    if (!jsonDict) {
        return nil;
    }
    
    NSMutableDictionary *myDict = [NSMutableDictionary new];
    
    NSString *songName = [[jsonDict valueForKey:@"track"]valueForKey:@"name"];
    [myDict setObject:songName forKey:@"songName"]; //Returns Song Name

    NSString *songArtist = [[[jsonDict valueForKey:@"track"]valueForKey:@"artist"]valueForKey:@"name"];
    [myDict setObject:songArtist forKey:@"songArtist"]; //Returns Song Artist

    NSArray *tags = @[[[[jsonDict valueForKey:@"track"]valueForKey:@"toptags"]valueForKey:@"tag"]];
    [myDict setObject:tags forKey:@"tags"]; //Returns array of tags. Access name property by: [[[myDictionary objectForKey:tags]objectAtIndex:index]valueForKey:@"name"];

    NSString *albumArtist = [[[jsonDict valueForKey:@"track"]valueForKey:@"album"]valueForKey:@"artist"];
    [myDict setObject:albumArtist forKey:@"albumArtist"]; //Returns Album artist. Some songs do not have albums so remember to check if result is nil when implementing or a crash will occur
    
    NSString *albumTitle = [[[jsonDict valueForKey:@"track"]valueForKey:@"album"]valueForKey:@"title"];
    [myDict setObject:albumTitle forKey:@"albumTitle"]; //Returns Album title. Some songs do not have albums so remember to check if result is nil when implementing or a crash will occur

    NSNumber *listenerCount = [[jsonDict valueForKey:@"track"]valueForKey:@"listeners"];
    [myDict setObject:listenerCount forKey:@"listenerCount"];//Returns the number of people who listened to the track. Remember to unwrap the NSNumber when implementing if needs be

    NSNumber *playCount = [[jsonDict valueForKey:@"track"]valueForKey:@"playcount"];
    [myDict setObject:playCount forKey:@"playCount"];//Returns the number of times the track has been played. Remember to unwrap the NSNumber when implementing if needs be
    
    NSArray *albumImages = [[[jsonDict valueForKey:@"track"]valueForKey:@"album"]valueForKey:@"image"];
    NSMutableArray *tempArray = [NSMutableArray new];
    if (albumImages) {
        for (int i = 0; i<albumImages.count; i++) {
            NSString *imageURLAsString = [[albumImages objectAtIndex:i]valueForKey:@"#text"];
            NSURL *imageURL = [NSURL URLWithString:imageURLAsString];
            NSData *rawImageData = [[NSData alloc]initWithContentsOfURL:imageURL];
            UIImage *image = [UIImage imageWithData:rawImageData];
            [tempArray addObject:image];
        }
        [myDict setObject:[tempArray objectAtIndex:0] forKey:@"smallAlbumImage"];//Returns small UIImage of album art if any. Some songs do not have albums so remember to check if result is nil when implementing or a crash will occur
        [myDict setObject:[tempArray objectAtIndex:1] forKey:@"mediumAlbumImage"];//Returns medium UIImage of album art if any. Some songs do not have albums so remember to check if result is nil when implementing or a crash will occur
        [myDict setObject:[tempArray objectAtIndex:2] forKey:@"largeAlbumImage"];//Returns large UIImage of album art if any. Some songs do not have albums so remember to check if result is nil when implementing or a crash will occur
        [myDict setObject:[tempArray objectAtIndex:3] forKey:@"XLAlbumImage"];//Returns XL UIImage of album art if any. Some songs do not have albums so remember to check if result is nil when implementing or a crash will occur
    }
    return myDict;

}

-(NSDictionary *)parseURL:(NSString *)URLAsString{
    
    NSError *error;
    
    NSData *jsonString = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:URLAsString] options:NSDataReadingUncached error:&error]; //Get all raw JSON from the URL and read it into a variable
    
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


