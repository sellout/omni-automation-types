{
  flake-utils,
  flaky,
  nixpkgs,
  self,
  systems,
}: let
  pname = "omni-automation-types";

  ## Official Omni Automation TypeScript definition files.
  ## See https://www.omni-automation.com/typescript/index.html
  ##
  ## The server requires a browser-like User-Agent, so we use fetchzip
  ## with curlOptsList rather than flake inputs.
  dtsBaseUrl = "https://www.omni-automation.com/typescript/ts-definition-files";
  userAgent = "Mozilla/5.0";

  supportedSystems = import systems;
in
  {
    schemas = {
      inherit
        (flaky.schemas)
        overlays
        homeConfigurations
        packages
        devShells
        projectConfigurations
        checks
        formatter
        ;
    };

    overlays.default = final: prev: {};

    lib = {};

    homeConfigurations =
      builtins.listToAttrs
      (builtins.map
        (flaky.lib.homeConfigurations.example self
          [({pkgs, ...}: {home.packages = [pkgs.${pname}];})])
        supportedSystems);
  }
  // flake-utils.lib.eachSystem supportedSystems (system: let
    pkgs = nixpkgs.legacyPackages.${system}.appendOverlays [
      flaky.overlays.default
    ];

    src = pkgs.lib.cleanSource ../..;
  in {
    packages = {
      default = self.packages.${system}.${pname};

      "${pname}" = let
        curlOptsList = ["-A" userAgent];

        zips = {
          omnifocus = {
            pname = "OmniFocus";
            hash = "sha256-kkI64eumNl9/PHlbWIW6ZQEgyT/CpcNPSpMk5QRBVgw=";
          };
          omnigraffle = {
            pname = "OmniGraffle";
            hash = "sha256-VnCMEbEHLnImqofvSqEFSnoMHLcsUM+FJcPhdvuNj1o=";
          };

          omnioutliner = {
            pname = "OmniOutliner";
            hash = "sha256-AcMyuMWPKyfX1sXK6gpPJzaJo1kP9OqJdjR8/85esl8=";
          };
          omniplan = {
            pname = "OmniPlan";
            hash = "sha256-aFoySjHo/oP73YCysobgTy5TnyMhDkfH6uUdhF+w2gU=";
          };
        };

        apps = pkgs.lib.mapAttrs (_: {
          pname,
          hash,
        }:
          pkgs.fetchzip {
            inherit hash;
            url = "${dtsBaseUrl}/${pname}.d.ts.zip";
          })
        zips;
      in
        pkgs.checkedDrv (pkgs.stdenv.mkDerivation {
          inherit pname;

          version = "0.1.0";

          src = pkgs.lib.cleanSource ../..;

          buildPhase = let
            ## Copy each app's supplementary .d.ts files (e.g., globals.d.ts)
            ## from the source tree into the output directories.
            copySupplementary = builtins.concatStringsSep "\n" (
              builtins.map (app: ''
                for f in ${app}/*.d.ts; do
                  [ -f "$f" ] && cp "$f" "out/${app}/"
                done
              '')
              (pkgs.lib.attrNames apps)
            );
          in ''
            mkdir -p out/omnifocus out/omnigraffle out/omnioutliner out/omniplan

            cp ${apps.omnifocus}/OmniFocus.d.ts out/omnifocus/index.d.ts
            cp ${apps.omnigraffle}/OmniGraffle.d.ts out/omnigraffle/index.d.ts
            cp ${apps.omnioutliner}/OmniOutliner.d.ts out/omnioutliner/index.d.ts
            cp ${apps.omniplan}/OmniPlan.d.ts out/omniplan/index.d.ts

            ${copySupplementary}
          '';

          installPhase = ''
            mkdir -p $out
            cp package.json $out/
            cp -r out/omnifocus out/omnigraffle out/omnioutliner out/omniplan $out/
          '';
        });
    };

    projectConfigurations =
      flaky.lib.projectConfigurations.default {inherit pkgs self;};

    devShells =
      self.projectConfigurations.${system}.devShells
      // {default = flaky.lib.devShells.default system self [] "";};
    checks = self.projectConfigurations.${system}.checks;
    formatter = self.projectConfigurations.${system}.formatter;
  })
