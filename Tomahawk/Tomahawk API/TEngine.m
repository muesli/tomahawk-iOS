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

+ (void)searchSongsBySongName:(NSString *)song resolver:(enum resolvers)resolver limit:(int)limit page:(int)page completion:(void (^)(id response))completion {
    NSString *baseURL;
    NSString *query;
    NSDictionary *params;
    switch (resolver) {
        case RSpotify:
            baseURL = SPOTIFY_BASE;
            query = @"/v1/search";
            params = @{@"q" : song, @"type" : @"track", @"limit" : @(limit), @"offset" : @(limit * page)};
            break;
        case RSoundcloud:
            baseURL = SOUNDCLOUD_BASE;
            query = @"/tracks/";
            params = @{@"q" : song, @"client_id" : SOUNDCLOUD_CLIENT_ID, @"limit" : @(limit), @"offset" : @(limit * page)};
            break;
        case RDeezer:{
            baseURL = DEEZER_BASE;
            query = @"/search/track";
            params = @{@"q" : song, @"limit" : @(limit), @"index" : @(limit * page)};
        }break;
        case RAppleMusic:
            baseURL = ITUNES_BASE;
            query = @"/search";
            params = @{@"term" : song, @"entity" : @"musicTrack", @"limit" : @(limit), @"offset" : @(limit * page)};
            break;
        case RYouTube:
            baseURL = YOUTUBE_BASE;
            query = @"/youtube/v3/search";
            params = @{@"part" : @"snippet", @"q" : song, @"type" : @"video", @"videoCategoryId" : @10, @"key" : YOUTUBE_API_KEY, @"maxResults" : @(limit)};
            break;
        default:
            break;
    }
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager GET:query parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableDictionary *myDict = [NSMutableDictionary new];
        NSMutableArray *songNames = [NSMutableArray new];
        NSMutableArray *artistNames = [NSMutableArray new];
        NSMutableArray *albumNames = [NSMutableArray new];
        NSMutableArray *songImages = [NSMutableArray new];
        NSArray *base;
        switch (resolver) {
            case RSpotify:
                base = [[responseObject objectForKey:@"tracks"]objectForKey:@"items"];
                for (int i = 0; i<base.count; i++) {
                    NSString *name = [[base objectAtIndex:i]objectForKey:@"name"];
                    NSString *artist = [[[[base objectAtIndex:i]objectForKey:@"artists"]objectAtIndex:0]objectForKey:@"name"];
                    NSString *album = [[[base objectAtIndex:i]objectForKey:@"album"]objectForKey:@"name"];
                    NSString *image = [[[[[base objectAtIndex:i]objectForKey:@"album"]objectForKey:@"images"]objectAtIndex:1]objectForKey:@"url"];
                    [artistNames addObject:artist];
                    [songNames addObject:name];
                    [albumNames addObject:album];
                    [songImages addObject:image];
                }
            break;
            case RSoundcloud:
                base = responseObject;
                for (int i = 0; i < base.count; i++) {
                    NSString *name = [[base objectAtIndex:i]objectForKey:@"title"];
                    NSString *artist = [[[base objectAtIndex:i]objectForKey:@"user"]objectForKey:@"username"];
                    NSString *images = [[base objectAtIndex:i]objectForKey:@"artwork_url"];
                    [songNames addObject:name];
                    [artistNames addObject:artist];
                    [songImages addObject:images];
                }
                
            break;
            case RDeezer:
                base = [responseObject objectForKey:@"data"];
                for (int i = 0; i<base.count; i++) {
                    NSString *name = [[base objectAtIndex:i]objectForKey:@"title"];
                    NSString *artist = [[[base objectAtIndex:i]objectForKey:@"artist"]objectForKey:@"name"];
                    NSString *album = [[[base objectAtIndex:i]objectForKey:@"album"]objectForKey:@"title"];
                    NSString *image = [[[base objectAtIndex:i]objectForKey:@"album"]objectForKey:@"cover"];
                    [songNames addObject:name];
                    [artistNames addObject:artist];
                    [albumNames addObject:album];
                    [songImages addObject:image];
                    
                }
            break;
            case RAppleMusic:
                base = [responseObject objectForKey:@"results"];
                for (int i = 0; i<base.count; i++) {
                    NSString *name = [[base objectAtIndex:i]objectForKey:@"trackName"];
                    NSString *artist = [[base objectAtIndex:i]objectForKey:@"artistName"];
                    NSString *album = [[base objectAtIndex:i]objectForKey:@"collectionName"];
                    NSString *image = [[base objectAtIndex:i]objectForKey:@"artworkUrl100"];
                    [songNames addObject:name];
                    [artistNames addObject:artist];
                    album == nil ? [albumNames addObject:@"Single"]:[albumNames addObject:album];
                    [songImages addObject:image];
                }
                break;
            case RYouTube:
                base = [responseObject objectForKey:@"items"];
                for (int i = 0; i<base.count; i++) {
                    NSString *name = [[[base objectAtIndex:i]objectForKey:@"snippet"]objectForKey:@"title"];
                    NSString *artist = [[[base objectAtIndex:i]objectForKey:@"snippet"]objectForKey:@"channelTitle"];
                    NSString *image = [[[[[base objectAtIndex:i]objectForKey:@"snippet"]objectForKey:@"thumbnails"]objectForKey:@"default"]objectForKey:@"url"];
                    [songNames addObject:name];
                    [artistNames addObject:artist];
                    [songImages addObject:image];
                }
            break;
            default:
                break;
        }
        [myDict setObject:songNames forKey:@"songNames"];
        [myDict setObject:artistNames forKey:@"artistNames"];
        albumNames.count == 0 ? : [myDict setObject:albumNames forKey:@"albumNames"];
        [myDict setObject:songImages forKey:@"songImages"];
        completion (myDict);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Failure: %@", error);
        completion (error);
    }];
}

+ (void)searchArtistsByArtistName:(NSString *)artist resolver:(enum resolvers)resolver limit:(int)limit page:(int)page completion:(void (^)(id response))completion {
    NSString *baseURL;
    NSString *query;
    NSDictionary *params;
    switch (resolver) {
        case RSpotify:
            baseURL = SPOTIFY_BASE;
            query = @"/v1/search";
            params = @{@"q" : artist, @"type" : @"artist", @"limit" : @(limit), @"offset" : @(limit * page)};
            break;
        case RSoundcloud:
            baseURL = SOUNDCLOUD_BASE;
            query = @"/users";
            params = @{@"q" : artist, @"client_id" : SOUNDCLOUD_CLIENT_ID, @"limit" : @(limit), @"offset" : @(limit * page)};
            break;
        case RDeezer:
            baseURL = DEEZER_BASE;
            query = @"/search/artist";
            params = @{@"q" : artist, @"limit" : @(limit), @"index" : @(limit * page)};
            break;
        case RLastFM:
            baseURL = LASTFM_BASE;
            page += 1;
            query = @"/2.0";
            params = @{@"artist" : artist, @"method" : @"artist.search", @"format" : @"json", @"api_key" : LASTFM_API_KEY, @"limit" : @(limit), @"page" : @(page)};
            break;
        case RYouTube:
            baseURL = YOUTUBE_BASE;
            query = @"/youtube/v3/search";
            params = @{@"part" : @"snippet", @"q" : artist, @"type" : @"channel", @"key" : YOUTUBE_API_KEY, @"maxResults" : @(limit)};
            break;
        default:
            break;
    }
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager GET:query parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableDictionary *myDict = [NSMutableDictionary new];
        NSMutableArray *artistNames = [NSMutableArray new];
        NSMutableArray *artistFollowers = [NSMutableArray new];
        NSMutableArray *artistImages = [NSMutableArray new];
        NSArray *base;
        switch (resolver) {
            case RSpotify:
                base = [[responseObject objectForKey:@"artists"]objectForKey:@"items"];
                for (int i = 0; i<base.count; i++) {
                    NSString *name = [[base objectAtIndex:i]objectForKey:@"name"];
                    NSNumber *followers = [[[base objectAtIndex:i]objectForKey:@"followers"]objectForKey:@"total"];
                    id image;
                    @try {image = [[[[base objectAtIndex:i]objectForKey:@"images"]objectAtIndex:1]objectForKey:@"url"];}
                    @catch (NSException *exception) {image = [NSNull null];}
                    @finally {[artistImages addObject:image];}
                    [artistNames addObject:name];
                    [artistFollowers addObject:followers];
                }
            break;
            case RSoundcloud:
                base = responseObject;
                for (int i = 0; i < base.count; i++) {
                    NSString *name = [[base objectAtIndex:i]objectForKey:@"username"];
                    NSNumber *followers = [[responseObject objectAtIndex:i]objectForKey:@"followers_count"];
                    NSString *images = [[responseObject objectAtIndex:i]objectForKey:@"avatar_url"];
                    [artistNames addObject:name];
                    [artistFollowers addObject:followers];
                    [artistImages addObject:images];
                }
            break;
            case RDeezer:
                base = [responseObject objectForKey:@"data"];
                for (int i = 0; i<base.count; i++) {
                    NSString *name = [[base objectAtIndex:i]objectForKey:@"name"];
                    NSNumber *followers = [[base objectAtIndex:i]objectForKey:@"nb_fan"];
                    NSString *image = [[base objectAtIndex:i]objectForKey:@"picture_medium"];
                    [artistNames addObject:name];
                    [artistFollowers addObject:followers];
                    [artistImages addObject:image];
                    
                }
            break;
            case RLastFM:
                base = [[[responseObject objectForKey:@"results"]objectForKey:@"artistmatches"]objectForKey:@"artist"];
                for (int i = 0; i<base.count; i++) {
                    NSString *name = [[base objectAtIndex:i]objectForKey:@"name"];
                    NSNumberFormatter *formatter = [NSNumberFormatter new];
                    [formatter setNumberStyle:NSNumberFormatterNoStyle];
                    NSNumber *followers = [formatter numberFromString:[[base objectAtIndex:i]objectForKey:@"listeners"]];
                    NSString *image = [[[[base objectAtIndex:i]objectForKey:@"image"]objectAtIndex:2]objectForKey:@"#text"];
                    [artistNames addObject:name];
                    [artistFollowers addObject:followers];
                    [artistImages addObject:image];
                }
            break;
            case RYouTube:
                base = [responseObject objectForKey:@"items"];
                for (int i = 0; i<base.count; i++) {
                    NSString *name = [[[base objectAtIndex:i]objectForKey:@"snippet"]objectForKey:@"title"];
                    NSString *channelID = [[[base objectAtIndex:i]objectForKey:@"id"]objectForKey:@"channelId"];
                    NSString *myURL = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/channels?part=statistics&id=%@&key=%@", channelID, YOUTUBE_API_KEY];
                    NSData *myData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:myURL] options:NSDataReadingMappedIfSafe error:nil];
                    NSDictionary *followerDict = [myData serialize];
                    NSNumberFormatter *formatter = [NSNumberFormatter new];
                    [formatter setNumberStyle:NSNumberFormatterNoStyle];
                    NSNumber *followers = [formatter numberFromString:[[[[followerDict objectForKey:@"items"]objectAtIndex:0]objectForKey:@"statistics"]objectForKey:@"subscriberCount"]];
                    NSString *image = [[[[[base objectAtIndex:i]objectForKey:@"snippet"]objectForKey:@"thumbnails"]objectForKey:@"default"]objectForKey:@"url"];
                    [artistNames addObject:name];
                    [artistFollowers addObject:followers];
                    [artistImages addObject:image];
                }
            break;
            default:
                break;
        }
        [myDict setObject:artistNames forKey:@"artistNames"];
        [myDict setObject:artistFollowers forKey:@"artistFollowers"];
        [myDict setObject:artistImages forKey:@"artistImages"];
        completion (myDict);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Failure: %@", error);
        completion (error);
    }];

}

+ (void)searchAlbumsByAlbumName:(NSString *)album resolver:(enum resolvers)resolver limit:(int)limit page:(int)page completion:(void (^)(id response))completion {
    NSString *baseURL;
    NSString *query;
    NSDictionary *params;
    switch (resolver) {
        case RSpotify:
            baseURL = SPOTIFY_BASE;
            query = @"/v1/search";
            params = @{@"q" : album, @"type" : @"album", @"limit" : @(limit), @"offset" : @(limit * page)};
            break;
        case RDeezer:
            baseURL = DEEZER_BASE;
            query = @"/search/album";
            params = @{@"q" : album, @"limit" : @(limit), @"index" : @(limit * page)};
            break;
        case RAppleMusic:
            baseURL = ITUNES_BASE;
            query = @"/search";
            params = @{@"term" : album, @"entity" : @"album", @"limit" : @(limit), @"offset" : @(limit * page)};
            break;
        default:
            break;
    }
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager GET:query parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableDictionary *myDict = [NSMutableDictionary new];
        NSMutableArray *albumNames = [NSMutableArray new];
        NSMutableArray *artistNames = [NSMutableArray new];
        NSMutableArray *albumImages = [NSMutableArray new];
        NSArray *base;
        switch (resolver) {
            case RSpotify:
                base = [[responseObject objectForKey:@"albums"]objectForKey:@"items"];
                for (int i = 0; i<base.count; i++) {
                    NSString *name = [[base objectAtIndex:i]objectForKey:@"name"];
                    NSString *albumArtistURL = [NSString stringWithFormat:@"https://api.spotify.com/v1/albums/%@", [[base objectAtIndex:i]objectForKey:@"id"]];
                    NSData *myData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:albumArtistURL] options:NSDataReadingMappedIfSafe error:nil];
                    NSDictionary *albumArtist = [myData serialize];
                    NSString *artist = [[[albumArtist objectForKey:@"artists"]objectAtIndex:0]objectForKey:@"name"];
                    NSString *image = [[[[base objectAtIndex:i]objectForKey:@"images"]objectAtIndex:1]objectForKey:@"url"];
                    [albumNames addObject:name];
                    [artistNames addObject:artist];
                    [albumImages addObject:image];
                }
            break;
            case RDeezer:
                base = [responseObject objectForKey:@"data"];
                for (int i = 0; i<base.count; i++) {
                    NSString *name = [[base objectAtIndex:i]objectForKey:@"title"];
                    NSString *artist = [[[base objectAtIndex:i]objectForKey:@"artist"]objectForKey:@"name"];
                    NSString *image = [[base objectAtIndex:i]objectForKey:@"cover"];
                    [albumNames addObject:name];
                    [artistNames addObject:artist];
                    [albumImages addObject:image];
                }
            break;
            case RAppleMusic:
                base = [responseObject objectForKey:@"results"];
                for (int i = 0; i<base.count; i++) {
                    NSString *name = [[base objectAtIndex:i]objectForKey:@"collectionName"];
                    NSString *artist = [[base objectAtIndex:i]objectForKey:@"artistName"];
                    NSString *image = [[base objectAtIndex:i]objectForKey:@"artworkUrl100"];
                    [albumNames addObject:name];
                    [artistNames addObject:artist];
                    [albumImages addObject:image];
                }
            break;
            default:
                break;
        }
        [myDict setObject:albumNames forKey:@"albumNames"];
        [myDict setObject:artistNames forKey:@"artistNames"];
        [myDict setObject:albumImages forKey:@"albumImages"];
        completion (myDict);
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
        AFOAuthCredential *credential = [AFOAuthCredential credentialWithOAuthToken:[[responseObject objectForKey:@"session"]objectForKey:@"key"] tokenType:@"Bearer"];
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
                error = [NSError errorWithDomain:@"com.mourke.Tomahawk.ErrorDomain" code:-4 userInfo: @{NSLocalizedDescriptionKey : [githubError objectForKey:@"message"]}];
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
        AFOAuthCredential *credential = [AFOAuthCredential credentialWithOAuthToken:[json objectForKey:@"access_token"] tokenType:@"Bearer"];
        NSDate *date = [NSDate dateWithTimeInterval:[[json objectForKey:@"expires"] doubleValue] sinceDate:[NSDate date]];
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
        AFOAuthCredential *credential = [AFOAuthCredential credentialWithOAuthToken:[responseObject objectForKey:@"access_token"] tokenType:@"Bearer"];
        NSDate *date = [NSDate dateWithTimeInterval:[[responseObject objectForKey:@"expires_in"] doubleValue] sinceDate:[NSDate date]];
        [credential setExpiration:date];
        credential.refreshToken = [responseObject objectForKey:@"refresh_token"];
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
        NSArray *base = [[responseObject objectForKey:@"tracks"]objectForKey:@"track"];
        NSMutableArray *songArtists = [NSMutableArray new];
        NSMutableArray *songNames = [NSMutableArray new];
        NSMutableArray *songImages = [NSMutableArray new];
        for (int i = 0; i<base.count; i++) {
            NSString *images = [[[[base objectAtIndex:i]objectForKey:@"image"]objectAtIndex:2]objectForKey:@"#text"];
            NSString *names = [[base objectAtIndex:i] objectForKey:@"name"];
            NSString *artists = [[[base objectAtIndex:i]objectForKey:@"artist"]objectForKey:@"name"];
            [songImages addObject:images];
            [songNames addObject:names];
            [songArtists addObject:artists];
        }
        [myDict setObject:songArtists forKey:@"songArtists"];
        [myDict setObject:songNames forKey:@"songNames"];
        [myDict setObject:songImages forKey:@"songImages"];
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
        NSArray *base = [[responseObject objectForKey:@"artists"]objectForKey:@"artist"];
        NSMutableArray *artistListeners = [NSMutableArray new];
        NSMutableArray *artistImages = [NSMutableArray new];
        NSMutableArray *artistNames = [NSMutableArray new];
        for (int i = 0; i<base.count; i++) {
            NSString *images = [[[[base objectAtIndex:i]objectForKey:@"image"]objectAtIndex:2]objectForKey:@"#text"];
            NSString *names = [[base objectAtIndex:i]objectForKey:@"name"];
            NSNumber *listeners = [[base objectAtIndex:i]objectForKey:@"listeners"];
            [artistImages addObject:images];
            [artistNames addObject:names];
            [artistListeners addObject:listeners];
        }
        [myDict setObject:artistListeners forKey:@"artistListeners"];
        [myDict setObject:artistNames forKey:@"artistNames"];
        [myDict setObject:artistImages forKey:@"artistImages"];
        completion(myDict);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion (error);
    }];
}


@end


