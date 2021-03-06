#import "VRUtils.h"


void dispatch_to_main_thread(dispatch_block_t block) {
  dispatch_async(dispatch_get_main_queue(), block);
}

void dispatch_to_global_queue(dispatch_block_t block) {
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

void dispatch_loop(size_t count, void (^block)(size_t)) {
  dispatch_apply(count, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

NSURL *common_parent_url(NSArray *fileUrls) {
  NSURL *firstUrl = fileUrls[0];

  if (fileUrls.count == 1) {
    return firstUrl.URLByDeletingLastPathComponent;
  }

  // from http://stackoverflow.com/questions/2845974/how-can-i-get-the-common-ancestor-directory-for-two-or-more-files-in-cocoa-obj-c

  NSArray *currentCommonComps = [firstUrl pathComponents];
  for (NSUInteger i = 1; i < fileUrls.count; i++) {
    NSArray *thisPathComps = [fileUrls[i] pathComponents];
    NSUInteger total = currentCommonComps.count;
    if (thisPathComps.count < total) {
      total = thisPathComps.count;
    }

    NSUInteger j;
    for (j = 0; j < total; j++) {
      if (![currentCommonComps[j] isEqualToString:thisPathComps[j]]) {
        break;
      }
    }

    if (j < currentCommonComps.count) {
      currentCommonComps = [currentCommonComps subarrayWithRange:NSMakeRange(0, j)];
    }

    if (currentCommonComps.count == 0) {
      break;
    }
  }

  return [NSURL fileURLWithPathComponents:currentCommonComps];
}

NSValue *vsize(CGSize size) {
  return [NSValue valueWithSize:size];
}

NSValue *vrect(CGRect rect) {
  return [NSValue valueWithRect:rect];
}

NSValue *vpoint(CGPoint point) {
  return [NSValue valueWithPoint:point];
}

NSArray *urls_from_paths(NSArray *paths) {
  NSMutableArray *urls = [[NSMutableArray alloc] initWithCapacity:paths.count];
  for (NSString *filename in paths) {
    [urls addObject:[[NSURL alloc] initFileURLWithPath:filename]];
  }

  return urls;
}

CGRect rect_with_origin(CGPoint origin, CGFloat width, CGFloat height) {
  return CGRectMake(origin.x, origin.y, width, height);
}
