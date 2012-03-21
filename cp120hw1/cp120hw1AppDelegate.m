//
//  cp120hw1AppDelegate.m
//  cp120hw1
//
//  Created by Jeremy McCarthy on 10/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cp120hw1AppDelegate.h"

@implementation cp120hw1AppDelegate

@synthesize window;
@synthesize helloButton;
@synthesize goodbyeButton;
@synthesize helloLabel;
@synthesize copyButton;
@synthesize copyTextField;
@synthesize numberSegmentedControl;
@synthesize numberLabel;
@synthesize seasonRadioButtons;
@synthesize seasonLabel;
@synthesize nowButton;
@synthesize nowLabel;
@synthesize squareSlider;
@synthesize squareNumberLabel;
@synthesize squareProductLabel;
@synthesize voiceSegmentedControl;
@synthesize voiceSlider;
@synthesize voiceButton;
@synthesize voiceScriptTextField;

- (id)init
{
    if ( self = [ super init ] ) {
        NSLog( @"base init reached" );
    }
    voiceSynthesizer = [ [ NSSpeechSynthesizer alloc ] init ];
    [ voiceSynthesizer setDelegate:self ];
    return self;
}

- (void)dealloc
{
    [ voiceSynthesizer release ];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [ self changeHelloLabel:helloButton ];
    [ self changeNumberLabel:numberSegmentedControl ];
    [ self changeSeasonLabel:seasonRadioButtons ];
    [ self changeNowLabel:nowButton ];
    [ self changeSquareSlider:squareSlider ];
    [ self changeVoice:voiceSegmentedControl ];
    [ self changeVoiceRate:voiceSlider ];
}

- (IBAction)changeHelloLabel:(id)sender {
    NSString *labelString;
    
    if ( [ sender isEqualTo:helloButton ] ) {
        labelString = @"Hello World!";
    }
    else if ( [ sender isEqualTo:goodbyeButton ] ) {
        labelString = @"Goodbye";
    }
    else if ( [ sender isEqual:copyButton ] ) {
        labelString = [ copyTextField stringValue ];
    }
    else {
        labelString = @"Error";
    }

    [ helloLabel setStringValue:labelString ];
}

- (IBAction)changeNumberLabel:(id)sender {
    NSInteger index = [ numberSegmentedControl selectedSegment ];
    
    if ( index == 0 ) {
        [ numberLabel setStringValue:@"0:Zero" ];
    }
    else if ( index == 1 ) {
        [ numberLabel setStringValue:@"1:One" ];
    }
    else if ( index == 2 ) {
        [ numberLabel setStringValue:@"2:Two" ];
    }
}

- (IBAction)changeSeasonLabel:(id)sender {
    NSString *seasonString = [ [ seasonRadioButtons selectedCell ] title ];
    
    if ( [ seasonString isEqualToString:@"Winter" ] ) {
        [ seasonLabel setStringValue:@"December" ];
    }
    else if ( [ seasonString isEqualToString:@"Spring" ] ) {
        [ seasonLabel setStringValue:@"March" ];
    }
    else if ( [ seasonString isEqualToString:@"Summer" ] ) {
        [ seasonLabel setStringValue:@"June" ];
    }
    else if ( [ seasonString isEqualToString:@"Fall" ] ) {
        [ seasonLabel setStringValue:@"September"];
    }
}

- (IBAction)changeNowLabel:(id)sender {
    NSDate *nowDate = [ NSDate date ];
    NSDateFormatter *dateFormatter = [ [ NSDateFormatter alloc ] init ];
    [ dateFormatter setTimeStyle:NSDateFormatterLongStyle ];
    [ dateFormatter setDateStyle:NSDateFormatterLongStyle ];
    [ nowLabel setStringValue:[ dateFormatter stringFromDate:nowDate ] ];
    [ dateFormatter release ];
}

- (IBAction)changeSquareSlider:(id)sender {
    double sliderValue = [ squareSlider doubleValue ];
    [squareNumberLabel setStringValue:[ NSString stringWithFormat:@"%.2f", sliderValue ] ];
    [squareProductLabel setStringValue:[ NSString stringWithFormat:@"%.2f", sliderValue * sliderValue ] ];
}

- (IBAction)changeVoice:(id)sender {
    [ voiceSynthesizer setVoice:[ NSString stringWithFormat:@"com.apple.speech.synthesis.voice.%@", [ sender labelForSegment:[ sender selectedSegment ] ] ] ];
    [ self changeVoiceRate:voiceSlider ];
}

- (IBAction)changeVoiceRate:(id)sender {
    [ voiceSynthesizer setRate:[ voiceSlider floatValue ] ];
}

- (IBAction)toggleVoicePlayback:(id)sender {
    if ( [ sender state ] == 1 ) {
        [ voiceSynthesizer startSpeakingString:[ voiceScriptTextField stringValue ] ];
    }
    else {
        [ voiceSynthesizer stopSpeaking ];
    }
}

- (void)speechSynthesizer:(NSSpeechSynthesizer *)sender didFinishSpeaking:(BOOL)finishedSpeaking {
    [ voiceButton setState:0 ];
}

- (void)printVoicesToLog {
    NSEnumerator *stringEnumerator = [ [ NSSpeechSynthesizer availableVoices] objectEnumerator ];
    NSString *tempString;
    
    while ( tempString = [ stringEnumerator nextObject ] ) {
        NSLog( @"%@", tempString );
    }
}
    
@end
