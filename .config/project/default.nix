### All available options for this file are listed in
### https://sellout.github.io/project-manager/options.xhtml
{lib, ...}: {
  project = {
    name = "omni-automation-types";
    summary = "TypeScript type definitions for the Omni Automation API";
  };

  ## There's no intersection between the systems supported by this flake and the
  ## ones supported by Nix CI.
  ##
  ## TODO: The Nix Ci module shouldn't try creating jobs for unsupported
  ##       systems.
  services.nix-ci.enable = lib.mkForce null;

  ## publishing
  services.github.settings.repository.topics = [];
  services.github.settings.repository.private = false;
}
