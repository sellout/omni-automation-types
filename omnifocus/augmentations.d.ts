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
