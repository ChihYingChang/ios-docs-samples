#import <Foundation/Foundation.h>

/// Available image formats to receive from the Spotify app.
typedef NS_ENUM(NSUInteger, SPTAppRemoteConnectionParamsImageFormat) {
    /// Any image format is acceptable. Use this if you don't care about which image format is sent.
    SPTAppRemoteConnectionParamsImageFormatAny = 0,
    /// JPEG image format.
    SPTAppRemoteConnectionParamsImageFormatJPEG,
    /// PNG image format.
    SPTAppRemoteConnectionParamsImageFormatPNG,
};

struct CGSize;

NS_ASSUME_NONNULL_BEGIN

/**
 * The `SPTAppRemoteconnectionParams` represents connection parameters required in order to initiate a connection
 * with the Spotify app.
 */
@interface SPTAppRemoteConnectionParams : NSObject

/**
 *  A unique identifier for the client.
 *
 *  @discussion The client key is used for authentication, and must be obtained from the Spotify developer portal.
 *
 *  @see https://developer.spotify.com/my-applications/#!/applications
 */
@property (nonatomic, copy, readonly) NSString *clientIdentifier;

/// The redirect URI for Spotify to open the client app after authentication.
@property (nonatomic, copy, readonly) NSString *redirectURI;

/// The name of the consumer application.
@property (nonatomic, copy, readonly) NSString *name;

/// The access token used to authorize the user with the Spotify app.
@property (nonatomic, copy, readwrite, nullable) NSString *accessToken;

/// The desired size of received images. (0,0) acts as a wildcard and accepts any size.
@property (nonatomic, assign, readonly) struct CGSize defaultImageSize;

/// The desired image format of received images.
@property (nonatomic, assign, readonly) SPTAppRemoteConnectionParamsImageFormat imageFormat;

/**
 *  Initialize a set of new connection parameters.
 *
 *  @discussion This is the designated initializer.
 *
 *  @param clientIdentifier The unique client key obtained from the Spotify developers website.
 *  @param redirectURI      The redirect URI for Spotify to open the client app after authentication.
 *  @param name             The name of the consumer application.
 *  @param accessToken      The access token obtained after authentication.
 *  @param defaultImageSize The desired size of received images. (0,0) acts as a wildcard and accepts any size.
 *  @param imageFormat      The desired image format of received images.
 *
 *  @return A set of connection parameters ready to be used when initiating a connection to the Spotify app.
 */
- (instancetype)initWithClientIdentifier:(NSString *)clientIdentifier
                             redirectURI:(NSString *)redirectURI
                                    name:(NSString *)name
                             accessToken:(nullable NSString *)accessToken
                        defaultImageSize:(struct CGSize)defaultImageSize
                             imageFormat:(SPTAppRemoteConnectionParamsImageFormat)imageFormat NS_DESIGNATED_INITIALIZER;

#pragma mark Static properties

/// Version of the protocol
@property (nonatomic, assign, readonly) NSInteger protocolVersion;

/// Roles
@property (nonatomic, copy, readonly) NSDictionary *roles;

/// Authentication methods supported
@property (nonatomic, copy, readonly) NSArray *authenticationMethods;

#pragma mark Unavailable initializers

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
