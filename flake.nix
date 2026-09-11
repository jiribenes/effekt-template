{
  ## TODO: Change to your project's description:
  description = "Nix template for Effekt projects";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    effekt-nix = {
      url = "github:jiribenes/effekt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, effekt-nix }:
    let
      ## Builds for all systems supported by effekt-nix.
      ## If you want only some specific systems, do the following instead:
      # systems = ["aarch64-linux" "aarch64-darwin"];
      systems = effekt-nix.lib.supportedSystems;

      forAllSystems = nixpkgs.lib.genAttrs systems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });

      ## Project configuration
      # TODO: Change to your project's details:
      pname = "effekt-template";         # package name
      version = "0.1.0";                 # package version
      mainFile = "src/main.effekt";      # relative path to entrypoint (as a string)
      testFiles = [ "src/test.effekt" ]; # relative paths to tests (as a string)

      ## Effekt configuration
      effektConfig = {
        ## Uncomment and set a specific version if needed:
        # version = "0.10.0";

        ## Select the backends that your project works on:
        backends = bs: [ bs.js ];
      };
    in {
      packages = forAllSystems (system:
        let
          effekt-lib = effekt-nix.lib.mkLib nixpkgsFor.${system};

          # Chooses the correct Effekt package.
          effektBuild = effekt-lib.getEffekt effektConfig;
        in {
          default = effekt-lib.buildEffektPackage {
            inherit pname version;
            src = ./.;
            main = mainFile;
            tests = testFiles;

            effekt = effektBuild;
            inherit (effektConfig) backends;
          };
        }
      );

      devShells = forAllSystems (system:
        let
          effekt-lib = effekt-nix.lib.mkLib nixpkgsFor.${system};

          # Chooses the correct Effekt package.
          effektBuild = effekt-lib.getEffekt effektConfig;
        in {
          default = effekt-lib.mkDevShell {
            effekt = effektBuild;
            inherit (effektConfig) backends;
          };
        }
      );
    };
}
