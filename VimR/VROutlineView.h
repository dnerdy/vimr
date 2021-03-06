/**
 * Tae Won Ha — @hataewon
 *
 * http://taewon.de
 * http://qvacua.com
 *
 * See LICENSE
 */

#import <Cocoa/Cocoa.h>
#import "VRMovementsAndActionsProtocol.h"


@protocol VRMovementsAndActionsProtocol;


@interface VROutlineView : NSOutlineView

@property id<VRMovementsAndActionsProtocol> movementsAndActionDelegate;

- (id)selectedItem;

@end
