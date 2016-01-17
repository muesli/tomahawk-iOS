//
//  TEngine.m
//  Tomahawk
//
//  Created by Mark Bourke on 28/11/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "TEngine.h"

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
        case RAppleMusic:
            baseURL = ITUNES_BASE;
            query = @"/search";
            params = @{@"term" : song, @"entity" : @"musicTrack", @"limit" : @4};
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
            case RAppleMusic:{
                NSMutableDictionary *myDict = [NSMutableDictionary new];
                
                NSArray *songNames = [[responseObject valueForKey:@"results"]valueForKey:@"trackName"];
                [myDict setObject:songNames forKey:@"songNames"];
                
                NSArray *artistNames = [[responseObject valueForKey:@"results"]valueForKey:@"artistName"];
                [myDict setObject:artistNames forKey:@"artistNames"];
                
                NSArray *albumNames = [[responseObject valueForKey:@"results"]valueForKey:@"collectionName"];
                [myDict setObject:albumNames forKey:@"albumNames"];
                
                NSArray *albumImages = [[responseObject valueForKey:@"results"]valueForKey:@"artworkUrl100"];
                [myDict setObject:albumImages forKey:@"mediumImages"];
                
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
    NSString *baseURL;
    NSString *query;
    NSDictionary *params;
    switch (resolver) {
        case RSpotify:
            baseURL = SPOTIFY_BASE;
            query = @"/v1/search";
            params = @{@"q" : artist, @"type" : @"artist", @"limit" : @4};
            break;
        case RSoundcloud:
            baseURL = SOUNDCLOUD_BASE;
            query = @"/users";
            params = @{@"q" : artist, @"client_id" : SOUNDCLOUD_CLIENT_ID, @"limit" : @4};
            break;
        case RDeezer:
            baseURL = DEEZER_BASE;
            query = @"/search/artist";
            params = @{@"q" : artist, @"limit" : @4};
            break;
        case RLastFM:
            baseURL = LASTFM_BASE;
            query = @"/2.0";
            params = @{@"artist" : artist, @"method" : @"artist.search", @"format" : @"json", @"api_key" : LASTFM_API_KEY, @"limit" : @4};
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
                
                NSArray *artistNames = [[[responseObject valueForKey:@"artists"]valueForKey:@"items"]valueForKey:@"name"];
                [myDict setObject:artistNames forKey:@"artistNames"];
                
                NSArray *artistFollowers = [[[[responseObject valueForKey:@"artists"]valueForKey:@"items"]valueForKey:@"followers"]valueForKey:@"total"];
                [myDict setObject:artistFollowers forKey:@"artistFollowers"];
                NSArray *artistImages = [[[responseObject valueForKey:@"artists"]valueForKey:@"items"]valueForKey:@"images"];
                
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
                [myDict setObject:images forKey:@"mediumImages"];
                completion (myDict);
            }break;
            case RSoundcloud:{
                NSMutableDictionary *myDict = [NSMutableDictionary new];
                
                NSArray *artistFollowers = [responseObject valueForKey:@"followers_count"];
                
                [myDict setObject:artistFollowers forKey:@"artistFollowers"];
                
                NSArray *artistNames = [responseObject valueForKey:@"username"];
                [myDict setObject:artistNames forKey:@"artistNames"];
                
                NSArray *artistImages = [responseObject valueForKey:@"avatar_url"];
                NSMutableArray *images = [NSMutableArray new];
                for (int i =0; i<artistImages.count; i++) {
                    if ([[artistImages objectAtIndex:i]isKindOfClass:[NSNull class]]) {
                        [images addObject:@""];
                    }else{
                        [images addObject:[artistImages objectAtIndex:i]];
                    }
                }
                [myDict setObject:images forKey:@"mediumImages"];
                
                completion (myDict);
            }break;
            case RDeezer: {
                NSMutableDictionary *myDict = [NSMutableDictionary new];
                
                NSArray *artistNames = [[responseObject valueForKey:@"data"]valueForKey:@"name"];
                [myDict setObject:artistNames forKey:@"artistNames"];
                
                NSArray *artistFollowers = [[responseObject valueForKey:@"data"]valueForKey:@"nb_fan"];
                [myDict setObject:artistFollowers forKey:@"artistFollowers"];
                
                NSArray *artistImages = [[responseObject valueForKey:@"data"]valueForKey:@"picture_medium"];
                [myDict setObject:artistImages forKey:@"mediumImages"];
                
                completion (myDict);
            }break;
            case RLastFM: {
                NSMutableDictionary *myDict = [NSMutableDictionary new];
                
                NSArray *artistNames = [[[[responseObject valueForKey:@"results"]valueForKey:@"artistmatches"]valueForKey:@"artist"]valueForKey:@"name"];
                [myDict setObject:artistNames forKey:@"artistNames"];
                
                NSArray *artistFollowers = [[[[responseObject valueForKey:@"results"]valueForKey:@"artistmatches"]valueForKey:@"artist"]valueForKey:@"listeners"];
                NSNumberFormatter *formatter = [NSNumberFormatter new];
                formatter.numberStyle = NSNumberFormatterNoStyle;
                
                NSArray *artistImages = [[[[responseObject valueForKey:@"results"]valueForKey:@"artistmatches"]valueForKey:@"artist"]valueForKey:@"image"];
                
                NSMutableArray *images = [NSMutableArray new];
                NSMutableArray *followers = [NSMutableArray new];
                for (int i = 0; i<artistImages.count; i++) {
                    NSString *imageURLAsString = [[[artistImages objectAtIndex:i]objectAtIndex:2]valueForKey:@"#text"];
                    [images addObject:imageURLAsString];
                    NSNumber *myNumber = [formatter numberFromString:[artistFollowers objectAtIndex:i]];
                    [followers addObject:myNumber];
                    
                }
                [myDict setObject:followers forKey:@"artistFollowers"];
                
                [myDict setObject:images forKey:@"mediumImages"];
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

+ (void)searchAlbumsByAlbumName:(NSString *)album resolver:(enum resolvers)resolver completion:(void (^)(id response))completion {
    NSString *baseURL;
    NSString *query;
    NSDictionary *params;
    switch (resolver) {
        case RSpotify:
            baseURL = SPOTIFY_BASE;
            query = @"/v1/search";
            params = @{@"q" : album, @"type" : @"album", @"limit" : @4};
            break;
        case RDeezer:
            baseURL = DEEZER_BASE;
            query = @"/search/album";
            params = @{@"q" : album, @"limit" : @4};
            break;
        case RAppleMusic:
            baseURL = ITUNES_BASE;
            query = @"/search";
            params = @{@"term" : album, @"entity" : @"album", @"limit" : @4};
            break;
        default:
            break;
    }
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager GET:query parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        switch (resolver) {
            case RSpotify:{
                NSArray *identifier = [[[responseObject valueForKey:@"albums"]valueForKey:@"items"]valueForKey:@"id"];
                
                NSMutableArray *artistNames = [NSMutableArray new];
                
                for (int i = 0; i<identifier.count; i++) {
                    NSString *albumArtistURL = @"https://api.spotify.com/v1/albums/";
                    albumArtistURL = [albumArtistURL stringByAppendingString:[identifier objectAtIndex:i]];
                    NSData *myData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:albumArtistURL] options:NSDataReadingMappedIfSafe error:nil];
                    NSDictionary *albumArtist = [myData serialize];
                    
                    NSString *artists = [[[albumArtist valueForKey:@"artists"]valueForKey:@"name"]objectAtIndex:0];
                    [artistNames addObject:artists];
                }
                
                
                NSMutableDictionary *myDict = [NSMutableDictionary new];
                
                [myDict setObject:artistNames forKey:@"artistNames"];
                
                NSArray *albumNames = [[[responseObject valueForKey:@"albums"]valueForKey:@"items"]valueForKey:@"name"];
                [myDict setObject:albumNames forKey:@"albumNames"];
                
                NSArray *albumImages = [[[responseObject valueForKey:@"albums"]valueForKey:@"items"]valueForKey:@"images"];
                
                NSMutableArray *images = [NSMutableArray new];
                
                for (int i = 0; i<albumImages.count; i++) {
                    NSString *imageURLAsString = [[[albumImages objectAtIndex:i]objectAtIndex:1]valueForKey:@"url"];
                    [images addObject:imageURLAsString];
                }
                [myDict setObject:images forKey:@"mediumImages"];
                completion (myDict);
            }break;
            case RDeezer: {
                NSMutableDictionary *myDict = [NSMutableDictionary new];
                
                NSArray *albumNames = [[responseObject valueForKey:@"data"]valueForKey:@"title"];
                [myDict setObject:albumNames forKey:@"albumNames"];
                
                NSArray *artistNames = [[[responseObject valueForKey:@"data"]valueForKey:@"artist"]valueForKey:@"name"];
                [myDict setObject:artistNames forKey:@"artistNames"];
                
                NSArray *albumImages = [[responseObject valueForKey:@"data"]valueForKey:@"cover"];
                [myDict setObject:albumImages forKey:@"mediumImages"];
                
                completion (myDict);
            }break;
            case RAppleMusic:{
                NSMutableDictionary *myDict = [NSMutableDictionary new];
                
                NSArray *albumNames = [[responseObject valueForKey:@"results"]valueForKey:@"collectionName"];
                [myDict setObject:albumNames forKey:@"albumNames"];
                
                NSArray *artistNames = [[responseObject valueForKey:@"results"]valueForKey:@"artistName"];
                [myDict setObject:artistNames forKey:@"artistNames"];
                
                NSArray *albumImages = [[responseObject valueForKey:@"results"]valueForKey:@"artworkUrl100"];
                [myDict setObject:albumImages forKey:@"mediumImages"];
                
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


@end


