/**
 * Tae Won Ha — @hataewon
 *
 * http://taewon.de
 * http://qvacua.com
 *
 * See LICENSE
 */

#import "VRBaseTestCase.h"
#import "VRMainWindowController.h"
#import "VRWorkspaceController.h"
#import "VRWorkspace.h"
#import "VRWorkspaceFactory.h"


@interface VRWorkspaceControllerTest : VRBaseTestCase

@end

@implementation VRWorkspaceControllerTest {
  VRWorkspaceController *workspaceController;

  MMVimManager *vimManager;
  MMVimController *vimController;
  VRWorkspaceFactory *workspaceFactory;
}

- (void)setUp {
  [super setUp];

  vimManager = mock([MMVimManager class]);
  vimController = mock([MMVimController class]);
  workspaceFactory = mock([VRWorkspaceFactory class]);

  workspaceController = [[VRWorkspaceController alloc] init];
  workspaceController.vimManager = vimManager;
  workspaceController.workspaceFactory = workspaceFactory;
}

- (void)testNewWorkspace {
  [given([vimManager pidOfNewVimControllerWithArgs:nil]) willReturnInt:123];
  [given([workspaceFactory newWorkspaceWithWorkingDir:instanceOf([NSURL class])]) willReturn:mock([VRWorkspace class])];

  [workspaceController newWorkspace];

  [verify(vimManager) pidOfNewVimControllerWithArgs:nil];
}

- (void)testOpenFiles {
  NSArray *urls = @[
      [NSURL URLWithString:@"file:///some/folder/is/1.txt"],
      [NSURL URLWithString:@"file:///some/folder/2.txt"],
      [NSURL URLWithString:@"file:///some/folder/is/there/3.txt"],
      [NSURL URLWithString:@"file:///some/folder/is/not/there/4.txt"],
  ];
  [given([vimManager pidOfNewVimControllerWithArgs:nil]) willReturnInt:123];
  [given([workspaceFactory newWorkspaceWithWorkingDir:instanceOf([NSURL class])]) willReturn:mock([VRWorkspace class])];

  [workspaceController openFilesInNewWorkspace:urls];
  [verify(vimManager) pidOfNewVimControllerWithArgs:@{
      qVimArgFileNamesToOpen : @[
          @"/some/folder/is/1.txt",
          @"/some/folder/2.txt",
          @"/some/folder/is/there/3.txt",
          @"/some/folder/is/not/there/4.txt",
      ],
      qVimArgOpenFilesLayout : @(MMLayoutTabs)
  }];
}

- (void)testCleanup {
  [workspaceController cleanUp];
  [verify(vimManager) terminateAllVimProcesses];
}

// cannot create NSWindow...
- (void)notTestManagerVimControllerCreated {
  NSArray *urls = @[
      [NSURL URLWithString:@"file:///some/folder/is/1.txt"],
      [NSURL URLWithString:@"file:///some/folder/2.txt"],
      [NSURL URLWithString:@"file:///some/folder/is/there/3.txt"],
      [NSURL URLWithString:@"file:///some/folder/is/not/there/4.txt"],
  ];
  [given([vimManager pidOfNewVimControllerWithArgs:nil]) willReturnInt:123];
  [workspaceController openFilesInNewWorkspace:urls];

  [workspaceController manager:vimManager vimControllerCreated:vimController];

  VRWorkspace *workspace = workspaceController.workspaces[0];
  assertThat(workspace.workingDirectory, is([NSURL fileURLWithPath:@"/some/folder"]));
  // cannot verify [workspace setUpWithVimController:vimController]
}

- (void)testManagerVimControllerRemovedWithControllerIdPid {
  [given([vimManager pidOfNewVimControllerWithArgs:nil]) willReturnInt:123];
  [given([workspaceFactory newWorkspaceWithWorkingDir:instanceOf([NSURL class])]) willReturn:mock([VRWorkspace class])];

  [workspaceController newWorkspace];

  [workspaceController manager:vimManager vimControllerRemovedWithControllerId:456 pid:123];

  assertThat(workspaceController.workspaces, isEmpty());
}

- (void)testMenuItemTemplateForManager {
  assertThat([workspaceController menuItemTemplateForManager:vimManager], isNot(nilValue()));
}

@end
