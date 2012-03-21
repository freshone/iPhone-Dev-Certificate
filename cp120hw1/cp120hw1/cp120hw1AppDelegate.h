//
//  cp120hw1AppDelegate.h
//  cp120hw1
//
//  Created by Jeremy McCarthy on 10/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface cp120hw1AppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
    NSButton *helloButton;
    NSButton *goodbyeButton;
    NSTextField *helloLabel;
    NSButton *copyButton;
    NSTextField *copyTextField;
    NSSegmentedControl *numberSegmentedControl;
    NSTextField *numberLabel;
    NSMatrix *seasonRadioButtons;
    NSTextField *seasonLabel;
    NSButton *nowButton;
    NSTextField *nowLabel;
    NSSlider *squareSlider;
    NSTextField *squareNumberLabel;
    NSTextField *squareProductLabel;
    NSSegmentedControl *voiceSegmentedControl;
    NSSlider *voiceSlider;
    NSButton *voiceButton;
    NSTextField *voiceScriptTextField;
    NSSpeechSynthesizer *voiceSynthesizer;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSButton *helloButton;
@property (assign) IBOutlet NSButton *goodbyeButton;
@property (assign) IBOutlet NSButton *copyButton;
@property (assign) IBOutlet NSTextField *helloLabel;
@property (assign) IBOutlet NSTextField *copyTextField;
@property (assign) IBOutlet NSSegmentedControl *numberSegmentedControl;
@property (assign) IBOutlet NSTextField *numberLabel;
@property (assign) IBOutlet NSMatrix *seasonRadioButtons;
@property (assign) IBOutlet NSTextField *seasonLabel;
@property (assign) IBOutlet NSButton *nowButton;
@property (assign) IBOutlet NSTextField *nowLabel;
@property (assign) IBOutlet NSSlider *squareSlider;
@property (assign) IBOutlet NSTextField *squareNumberLabel;
@property (assign) IBOutlet NSTextField *squareProductLabel;
@property (assign) IBOutlet NSSegmentedControl *voiceSegmentedControl;
@property (assign) IBOutlet NSSlider *voiceSlider;
@property (assign) IBOutlet NSButton *voiceButton;
@property (assign) IBOutlet NSTextField *voiceScriptTextField;

- (IBAction)changeHelloLabel:(id)sender;
- (IBAction)changeNumberLabel:(id)sender;
- (IBAction)changeSeasonLabel:(id)sender;
- (IBAction)changeNowLabel:(id)sender;
- (IBAction)changeSquareSlider:(id)sender;
- (IBAction)changeVoice:(id)sender;
- (IBAction)changeVoiceRate:(id)sender;
- (IBAction)toggleVoicePlayback:(id)sender;
- (void)speechSynthesizer:(NSSpeechSynthesizer *)sender didFinishSpeaking:(BOOL)finishedSpeaking;
- (void)printVoicesToLog;

@end
