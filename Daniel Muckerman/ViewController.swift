//
//  ViewController.swift
//  Daniel Muckerman
//
//  Created by Daniel Muckerman on 4/24/15.
//  Copyright (c) 2015 Daniel Muckerman. All rights reserved.
//

import Cocoa

// Override NSWindow for light/dark mode checks
class PresentWindow: NSWindow {
    
    // Set window color to current OSX color mode
    override func awakeFromNib() {
        let osxMode = NSUserDefaults.standardUserDefaults().stringForKey("AppleInterfaceStyle") ?? "Light"
        
        if (osxMode == "Dark") {
            self.appearance = NSAppearance(named: NSAppearanceNameVibrantDark)
        }
    }
}

class ViewController: NSViewController, NSTextViewDelegate {
    
    // Text view for code
    @IBOutlet var textView: CodeTextView!
    
    // On first run
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Enable line numbers
        if let scrollView = textView.enclosingScrollView {
            var rulerView = LineNumberRulerView(textView: textView)
            scrollView.verticalRulerView = rulerView
            scrollView.hasVerticalRuler = true
            scrollView.rulersVisible = true
        }
        
        // Enable rich text in the text view
        textView.delegate = self
        textView.richText = true
        
        // Set line spacing for the text view
        var theParagraphStyle = NSMutableParagraphStyle()
        theParagraphStyle.lineSpacing = 1.2
        textView.defaultParagraphStyle = theParagraphStyle
        
        // Load org file into the text view
        var path = NSBundle.mainBundle().pathForResource("WWDC_submission", ofType:"org")
        var contents = String(contentsOfFile: path!, encoding: NSUTF8StringEncoding, error: nil)
        if (contents != nil) {
            textView.string = contents
            
            // Format the text view based on the org file format
            orgFormatting()
        }
    }

    // Whenever an edit is made, update the formatting
    func textDidChange(notification: NSNotification) {
        // Format the text view based on the org file format
        orgFormatting()
    }
    
    // Format the text view based on the org file format
    func orgFormatting() {
        // Extract contents of textview
        var contents = textView.string
        
        // Set default font, size and color
        textView.setFont(NSFont(name: "Input", size: 12.0)!, range: NSMakeRange(0, count(contents!)))
        textView.setTextColor(NSColor(red:0.78, green:0.78, blue:0.78, alpha:1), range: NSMakeRange(0, count(contents!)))
        
        if (contents != nil) {
            // Find all level 1 headers in the document
            var h1Matches = NSRegularExpression(pattern: "^\\*\\s[A-Za-z0-9&\\'\\?\\ ]+$", options: .AnchorsMatchLines, error: nil)!.matchesInString(contents!, options: nil, range:NSMakeRange(0, count(contents!)))
            
            // Find all level 2 headers in the document
            var h2Matches = NSRegularExpression(pattern: "^\\*\\*\\s[A-Za-z0-9&\\'\\?\\ ]+$", options: .AnchorsMatchLines, error: nil)!.matchesInString(contents!, options: nil, range:NSMakeRange(0, count(contents!)))
            
            // Find all metadata in the document
            var commentMatches = NSRegularExpression(pattern: "^#\\+[A-Za-z0-9\\_:\\s]+$", options: .AnchorsMatchLines, error: nil)!.matchesInString(contents!, options: nil, range:NSMakeRange(0, count(contents!)))
            
            // Find all Clojures in the document
            var clojureMatches = NSRegularExpression(pattern: "Clojure", options: .AnchorsMatchLines, error: nil)!.matchesInString(contents!, options: nil, range:NSMakeRange(0, count(contents!)))
            
            // Find all Perls in the document
            var perlMatches = NSRegularExpression(pattern: "Perl", options: .AnchorsMatchLines, error: nil)!.matchesInString(contents!, options: nil, range:NSMakeRange(0, count(contents!)))
            
            // Find all Objective-Cs in the document
            var objMatches = NSRegularExpression(pattern: "Objective-C", options: .AnchorsMatchLines, error: nil)!.matchesInString(contents!, options: nil, range:NSMakeRange(0, count(contents!)))
            
            // Find all Swifts in the document
            var swiftMatches = NSRegularExpression(pattern: "Swift", options: .AnchorsMatchLines, error: nil)!.matchesInString(contents!, options: nil, range:NSMakeRange(0, count(contents!)))
            
            // Find all Javas in the document
            var javaMatches = NSRegularExpression(pattern: "Java", options: .AnchorsMatchLines, error: nil)!.matchesInString(contents!, options: nil, range:NSMakeRange(0, count(contents!)))
            
            // Find all Orgs/Org-modes in the document
            var orgMatches = NSRegularExpression(pattern: "Org-mode|Org", options: .AnchorsMatchLines, error: nil)!.matchesInString(contents!, options: nil, range:NSMakeRange(0, count(contents!)))
            
            // Find all HTML/CSSs in the document
            var htmlMatches = NSRegularExpression(pattern: "HTML/CSS|HTML|CSS", options: .AnchorsMatchLines, error: nil)!.matchesInString(contents!, options: nil, range:NSMakeRange(0, count(contents!)))
            
            // Find all C++s in the document
            var cppMatches = NSRegularExpression(pattern: "C\\+\\+", options: .AnchorsMatchLines, error: nil)!.matchesInString(contents!, options: nil, range:NSMakeRange(0, count(contents!)))
            
            // If there is any metadata
            if (count(commentMatches) > 0) {
                // Loop through array of metadata
                for i in 0...commentMatches.count-1 {
                    // Set color and size of metadata
                    var titleMatches = NSRegularExpression(pattern: "\\s.*$", options: .AnchorsMatchLines, error: nil)!.matchesInString(contents!, options: nil, range: commentMatches[i].range)
                    textView.setTextColor(NSColor(red:1, green:0.739, blue:0.445, alpha:1), range: NSMakeRange(commentMatches[i].range.location, titleMatches[0].range.location))
                    textView.setTextColor(NSColor(red:0.38, green:0.69, blue:0.84, alpha:1), range: titleMatches[0].range)
                    textView.setFont(NSFont(name: "Input Bold", size: 12.0)!, range: titleMatches[0].range)
                }
            }
            
            // If there are any level 1 headers
            if (count(h1Matches) > 0) {
                // Loop through array of level 1 headers
                for i in 0...h1Matches.count-1 {
                    // Set color and size of level 1 headers
                    textView.setTextColor(NSColor(red:0.38, green:0.69, blue:0.84, alpha:1), range: h1Matches[i].range)
                    textView.setFont(NSFont(name: "Input", size: 26.4)!, range: h1Matches[i].range)
                }
            }
            
            // If there are any level 2 headers
            if (count(h2Matches) > 0) {
                // Loop through array of level 2 headers
                for i in 0...h2Matches.count-1 {
                    // Set color and size of level 2 headers
                    textView.setTextColor(NSColor(red:0.62, green:0.86, blue:0.19, alpha:1), range: h2Matches[i].range)
                    textView.setFont(NSFont(name: "Input", size: 21.6)!, range: h2Matches[i].range)
                }
            }
            
            // If there are any Objective-Cs
            if (count(objMatches) > 0) {
                // Loop through array of Objective-Cs
                for i in 0...objMatches.count-1 {
                    // Set color and size of Objective-Cs
                    textView.setTextColor(NSColor(red:1, green:0.577, blue:0.78, alpha:1), range: objMatches[i].range)
                }
            }
            
            // If there are any Perls
            if (count(perlMatches) > 0) {
                // Loop through array of Perls
                for i in 0...perlMatches.count-1 {
                    // Set color and size of Perls
                    textView.setTextColor(NSColor(red:0.859, green:0.634, blue:1, alpha:1), range: perlMatches[i].range)
                }
            }
            
            // If there are any Clojures
            if (count(clojureMatches) > 0) {
                // Loop through array of Clojures
                for i in 0...clojureMatches.count-1 {
                    // Set color and size of Clojures
                    textView.setTextColor(NSColor(red:0.731, green:0.981, blue:0, alpha:1), range: clojureMatches[i].range)
                }
            }
            
            // If there are any Swifts
            if (count(swiftMatches) > 0) {
                // Loop through array of Swifts
                for i in 0...swiftMatches.count-1 {
                    // Set color and size of Swifts
                    textView.setTextColor(NSColor(red:0.88, green:0.454, blue:0, alpha:1), range: swiftMatches[i].range)
                }
            }
            
            // If there are any Javas
            if (count(javaMatches) > 0) {
                // Loop through array of Javas
                for i in 0...javaMatches.count-1 {
                    // Set color and size of Javas
                    textView.setTextColor(NSColor(red:0.813, green:0.681, blue:0, alpha:1), range: javaMatches[i].range)
                }
            }
            
            // If there are any Orgs/Org-modes
            if (count(orgMatches) > 0) {
                // Loop through array of Orgs/Org-modes
                for i in 0...orgMatches.count-1 {
                    // Set color and size of Orgs/Org-modes
                    textView.setTextColor(NSColor(red:0.676, green:0.227, blue:1, alpha:1), range: orgMatches[i].range)
                }
            }
            
            // If there are any HTML/CSSs
            if (count(htmlMatches) > 0) {
                // Loop through array of HTML/CSSs
                for i in 0...htmlMatches.count-1 {
                    // Set color and size of HTML/CSSs
                    textView.setTextColor(NSColor(red:0, green:0.585, blue:0, alpha:1), range: htmlMatches[i].range)
                }
            }
            
            // If there are any C++s
            if (count(cppMatches) > 0) {
                // Loop through array of C++s
                for i in 0...cppMatches.count-1 {
                    // Set color and size of C++s
                    textView.setTextColor(NSColor(red:0.96, green:0.257, blue:0.208, alpha:1), range: cppMatches[i].range)
                }
            }
        }
    }
}

