#import "Launcher.h"
#import <Cordova/CDV.h>

@implementation Launcher

- (void)canLaunch:(CDVInvokedUrlCommand*)command {
	NSDictionary* options = [command.arguments objectAtIndex:0];
	CDVPluginResult * pluginResult = nil;

	if ([options objectForKey:@"uri"]) {
		NSString *uri = [options objectForKey:@"uri"];
		if ([[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:uri]]) {
			 pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
			[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
		} else {
			pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"No app installed that can handle that uri."];
			[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
		}
	} else {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Missing option: 'uri' required."];
		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
	}
}

- (void)launch:(CDVInvokedUrlCommand*)command {
	NSDictionary* options = [command.arguments objectAtIndex:0];
	CDVPluginResult *pluginResult = nil;

	if ([options objectForKey:@"uri"]) {
		NSString *uri = [options objectForKey:@"uri"];
		NSURL *launchURL = [NSURL URLWithString:uri];

		if ([[UIApplication sharedApplication] canOpenURL:launchURL]) {
			[[UIApplication sharedApplication] openURL:launchURL
                                               options:@{}
                                     completionHandler:^(BOOL success) {
				CDVPluginResult *result;
				if (success) {
					result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
				} else {
					result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Failed to open the URI."];
				}
				[self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
			}];
		} else {
			pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"No app installed that can handle that URI."];
			[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
		}
	} else {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Missing option: 'uri' required."];
		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
	}
}

@end
