// Augmentations for the official OmniFocus type definitions.
//
// PlugIn.Library: the documented pattern for Omni Automation libraries
// is to assign methods as properties (lib.myMethod = function() {...}).
// The auto-generated official type only declares the base class members.
declare namespace PlugIn {
  interface Library {
    [key: string]: any;
  }
}

// Task.noteText: added in OmniFocus 4 but missing from the August 2021
// official .d.ts. Returns the note content as a rich Text object (as
// opposed to the plain-string `note` property).
declare interface Task {
  readonly noteText: Text;
}
