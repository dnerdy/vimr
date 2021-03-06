/**
 * Tae Won Ha — @hataewon
 *
 * http://taewon.de
 * http://qvacua.com
 *
 * See LICENSE
 */

#import <Cocoa/Cocoa.h>


@protocol VRMovementsAndActionsProtocol

@optional
- (void)viMotionLeft:(id)sender event:(NSEvent *)event;
- (void)viMotionUp:(id)sender event:(NSEvent *)event;
- (void)viMotionDown:(id)sender event:(NSEvent *)event;
- (void)viMotionRight:(id)sender event:(NSEvent *)event;

- (void)actionSpace:(id)sender event:(NSEvent *)event;
- (void)actionCarriageReturn:(id)sender event:(NSEvent *)event;

- (void)actionEscape:(id)sender event:(NSEvent *)event;

@end
