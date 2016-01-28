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

+ (void)searchSongsBySongName:(NSString *)song resolver:(enum resolvers)resolver limit:(NSNumber *)limit page:(NSNumber *)page completion:(void (^)(id response))completion {
    NSString *baseURL;
    NSString *query;
    NSDictionary *params;
    switch (resolver) {
        case RSpotify:
            baseURL = SPOTIFY_BASE;
            query = @"/v1/search";
            params = @{@"q" : song, @"type" : @"track", @"limit" : limit};
            break;
        case RSoundcloud:
            baseURL = SOUNDCLOUD_BASE;
            query = @"/tracks/";
            params = @{@"q" : song, @"client_id" : SOUNDCLOUD_CLIENT_ID, @"limit" : limit};
            break;
        case RDeezer:{
            baseURL = DEEZER_BASE;
            query = @"/search/track";
            params = @{@"q" : song, @"limit" : limit, @"index" : @([limit intValue] * [page intValue])};
        }break;
        case RAppleMusic:
            baseURL = ITUNES_BASE;
            query = @"/search";
            params = @{@"term" : song, @"entity" : @"musicTrack", @"limit" : limit};
            break;
        case RYouTube:
            baseURL = YOUTUBE_BASE;
            query = @"/youtube/v3/search";
            params = @{@"part" : @"snippet", @"q" : song, @"type" : @"video", @"videoCategoryId" : @10, @"key" : YOUTUBE_API_KEY, @"maxResults" : limit};
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
            case RYouTube:{
                NSMutableDictionary *myDict = [NSMutableDictionary new];
                
                NSArray *songNames = [[[responseObject valueForKey:@"items"]valueForKey:@"snippet"]valueForKey:@"title"];
                [myDict setObject:songNames forKey:@"songNames"];
                
                NSArray *artistNames = [[[responseObject valueForKey:@"items"]valueForKey:@"snippet"]valueForKey:@"channelTitle"];
                [myDict setObject:artistNames forKey:@"artistNames"];
                
                NSArray *albumImages = [[[[[responseObject valueForKey:@"items"]valueForKey:@"snippet"]valueForKey:@"thumbnails"]valueForKey:@"default"]valueForKey:@"url"];
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

+ (void)searchArtistsByArtistName:(NSString *)artist resolver:(enum resolvers)resolver limit:(NSNumber *)limit page:(NSNumber *)page completion:(void (^)(id response))completion {
    NSString *baseURL;
    NSString *query;
    NSDictionary *params;
    switch (resolver) {
        case RSpotify:
            baseURL = SPOTIFY_BASE;
            query = @"/v1/search";
            params = @{@"q" : artist, @"type" : @"artist", @"limit" : limit};
            break;
        case RSoundcloud:
            baseURL = SOUNDCLOUD_BASE;
            query = @"/users";
            params = @{@"q" : artist, @"client_id" : SOUNDCLOUD_CLIENT_ID, @"limit" : limit};
            break;
        case RDeezer:
            baseURL = DEEZER_BASE;
            query = @"/search/artist";
            params = @{@"q" : artist, @"limit" : limit};
            break;
        case RLastFM:
            baseURL = LASTFM_BASE;
            query = @"/2.0";
            params = @{@"artist" : artist, @"method" : @"artist.search", @"format" : @"json", @"api_key" : LASTFM_API_KEY, @"limit" : limit};
            break;
        case RYouTube:
            baseURL = YOUTUBE_BASE;
            query = @"/youtube/v3/search";
            params = @{@"part" : @"snippet", @"q" : artist, @"type" : @"channel", @"key" : YOUTUBE_API_KEY, @"maxResults" : limit};
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
            case RYouTube:{
                NSMutableDictionary *myDict = [NSMutableDictionary new];
                
                NSArray *artistNames = [[responseObject valueForKey:@"items"]valueForKey:@"snippet"];
                [myDict setObject:artistNames forKey:@"artistNames"];
                
                NSArray *artistFollowers = [[responseObject valueForKey:@"data"]valueForKey:@"nb_fan"];
                [myDict setObject:artistFollowers forKey:@"artistFollowers"];
                
                NSArray *artistImages = [[responseObject valueForKey:@"data"]valueForKey:@"picture_medium"];
                [myDict setObject:artistImages forKey:@"mediumImages"];
                
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

+ (void)searchAlbumsByAlbumName:(NSString *)album resolver:(enum resolvers)resolver limit:(NSNumber *)limit page:(NSNumber *)page completion:(void (^)(id response))completion {
    NSString *baseURL;
    NSString *query;
    NSDictionary *params;
    switch (resolver) {
        case RSpotify:
            baseURL = SPOTIFY_BASE;
            query = @"/v1/search";
            params = @{@"q" : album, @"type" : @"album", @"limit" : limit};
            break;
        case RDeezer:
            baseURL = DEEZER_BASE;
            query = @"/search/album";
            params = @{@"q" : album, @"limit" : limit};
            break;
        case RAppleMusic:
            baseURL = ITUNES_BASE;
            query = @"/search";
            params = @{@"term" : album, @"entity" : @"album", @"limit" : limit};
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

+(void)authorizeLastFMWithUsername:(NSString *)username password:(NSString *)password completion:(void (^)(id))completion {
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:@"lastFM"];
    if (credential !=nil) {
        completion (@"Sucess");
        return;
    }
     NSString *api_sig = [NSString stringWithFormat:@"api_key%@methodauth.getMobileSessionpassword%@username%@%@", LASTFM_API_KEY, password, username, LASTFM_SECRET_KEY];
    NSDictionary *params = @{@"method" : @"auth.getMobileSession", @"api_key" : LASTFM_API_KEY, @"format" : @"json", @"username" : username, @"password" : password, @"api_sig" : api_sig.md5};
    
    AFHTTPSessionManager *session = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:LASTFM_BASE] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [session POST:@"/2.0" parameters:params constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id  responseObject) {
        AFOAuthCredential *credential = [AFOAuthCredential credentialWithOAuthToken:[[responseObject valueForKey:@"session"]valueForKey:@"key"] tokenType:@"Bearer"];
        [AFOAuthCredential storeCredential:credential withIdentifier:@"lastFM"];
        completion(@"Success");
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion (error);
    }];
}

+ (void)reportBugWithTitle:(NSString *)title description:(NSString *)body username:(NSString *)assignee password:(NSString *)password completion:(void (^)(id response))completion {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (assignee) [params setObject:assignee forKey:@"assignee"];
    if (body) [params setObject:body forKey:@"body"];
    
    [params setObject:title forKey:@"title"];
    
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
    if (credential != nil && credential.expired == FALSE) {
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
    } failure:^(NSError *error) {
        NSLog(@"error is %@", error);
        completion (error);
    }];
}

+(void)authorizeDeezerWithCode:(NSString *)code completion:(void (^)(id response))completion {
    NSDictionary *params = @{@"app_id" : @170391, @"code" : code, @"secret" : DEEZER_SECRET};
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:@"deezer"];
    if (credential != nil && credential.expired == FALSE) {
        NSLog(@"Credential Not Expired: %@", [credential valueForKey:@"expiration"]);
        completion (@"Sucess");
        return;
    }
    
    AFHTTPSessionManager *session = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:@"https://connect.deezer.com"] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    [session POST:@"/oauth/access_token.php" parameters:params constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *myString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *json = [myString URLStringValues];
        AFOAuthCredential *credential = [AFOAuthCredential credentialWithOAuthToken:[json valueForKey:@"access_token"] tokenType:@"Bearer"];
        NSDate *date = [NSDate dateWithTimeInterval:[[json valueForKey:@"expires"] doubleValue] sinceDate:[NSDate date]];
        [credential setExpiration:date];
        [AFOAuthCredential storeCredential:credential withIdentifier:@"deezer"];
        completion(@"Success");
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error is %@", error);
        completion (error);
    }];
}

+(void)authorizeSoundcloudWithCode:(NSString *)code completion:(void (^)(id response))completion {
    NSDictionary *params = @{@"grant_type" : @"authorization_code", @"code" : code, @"redirect_uri" : @"Tomahawk://Soundcloud", @"client_id" : SOUNDCLOUD_CLIENT_ID, @"client_secret" : SOUNDCLOUD_CLIENT_SECRET};
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:@"soundcloud"];
    if (credential != nil && credential.expired == FALSE) {
        NSLog(@"Credential Not Expired: %@", [credential valueForKey:@"expiration"]);
        completion (@"Sucess");
        return;
    }else if (credential != nil && credential.refreshToken != nil){
        NSLog(@"Refreshing Token");
        params = @{@"grant_type" : @"refresh_token", @"refresh_token" : credential.refreshToken, @"redirect_uri" : @"Tomahawk://Soundcloud", @"client_id" : SOUNDCLOUD_CLIENT_ID, @"client_secret" : SOUNDCLOUD_CLIENT_SECRET};
    }
    AFHTTPSessionManager *session = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:@"https://api.soundcloud.com"] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    session.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [session POST:@"/oauth2/token" parameters:params constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id  responseObject) {
        AFOAuthCredential *credential = [AFOAuthCredential credentialWithOAuthToken:[responseObject valueForKey:@"access_token"] tokenType:@"Bearer"];
        NSDate *date = [NSDate dateWithTimeInterval:[[responseObject valueForKey:@"expires_in"] doubleValue] sinceDate:[NSDate date]];
        [credential setExpiration:date];
        credential.refreshToken = [responseObject valueForKey:@"refresh_token"];
        [AFOAuthCredential storeCredential:credential withIdentifier:@"soundcloud"];
        completion (@"Success");
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error is %@", error);
        completion (error);
    }];

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

+(void)getTopTracksWithCompletionBlock:(void (^)(id response))completion {
    NSDictionary *params = @{@"method" : @"chart.getTopTracks", @"api_key" : LASTFM_API_KEY, @"format" : @"json", @"limit" : @4};
    
    AFHTTPSessionManager *session = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:LASTFM_BASE] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    session.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [session GET:@"/2.0" parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableDictionary *myDict = [NSMutableDictionary dictionary];
        NSArray *songNames = [[[responseObject valueForKey:@"tracks"]valueForKey:@"track"]valueForKey:@"name"];
        [myDict setObject:songNames forKey:@"songNames"];
        
        NSArray *artistNames = [[[[responseObject valueForKey:@"tracks"]valueForKey:@"track"]valueForKey:@"artist"]valueForKey:@"name"];
        [myDict setObject:artistNames forKey:@"artistNames"];
        
        NSArray *songImages = [[[responseObject valueForKey:@"tracks"]valueForKey:@"track"]valueForKey:@"image"];
        NSMutableArray *images = [NSMutableArray new];
        for (int i = 0; i<songImages.count; i++) {
            NSString *imageURLAsString = [[[songImages objectAtIndex:i]objectAtIndex:2]valueForKey:@"#text"];
            [images addObject:imageURLAsString];
        }
        [myDict setObject:images forKey:@"mediumImages"];
        completion(myDict);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion (error);
    }];
 
}

+(void)getTopArtistsWithCompletionBlock:(void (^)(id response))completion {
    NSDictionary *params = @{@"method" : @"chart.getTopArtists", @"api_key" : LASTFM_API_KEY, @"format" : @"json", @"limit" : @4};
    
    AFHTTPSessionManager *session = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:LASTFM_BASE] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    session.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [session GET:@"/2.0" parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableDictionary *myDict = [NSMutableDictionary dictionary];
        NSArray *artistNames = [[[responseObject valueForKey:@"artists"]valueForKey:@"artist"]valueForKey:@"name"];
        [myDict setObject:artistNames forKey:@"artistNames"];
        NSArray *artistListeners = [[[responseObject valueForKey:@"artists"]valueForKey:@"artist"]valueForKey:@"listeners"];
        [myDict setObject:artistListeners forKey:@"artistListeners"];
        NSArray *artistImages = [[[responseObject valueForKey:@"artists"]valueForKey:@"artist"]valueForKey:@"image"];
        NSMutableArray *images = [NSMutableArray new];
        for (int i = 0; i<artistImages.count; i++) {
            NSString *imageURLAsString = [[[artistImages objectAtIndex:i]objectAtIndex:2]valueForKey:@"#text"];
            [images addObject:imageURLAsString];
        }
        [myDict setObject:images forKey:@"mediumImages"];
        completion(myDict);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion (error);
    }];
}


@end


