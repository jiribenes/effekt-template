{
  description = "Nix template for Effekt projects";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    effekt-nix = {
      url = "github:jiribenes/effekt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows ="flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils, effekt-nix }:
    # If you want only some specific systems, do the following instead:
    # flake-utils.lib.eachSystem ["aarch64-linux" "aarch64-darwin"] (system:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        effekt-lib = effekt-nix.lib.${system};

        # You can set a fixed Effekt version and your supported backends here:
        effektVersion = "0.3.0";
        backends = with effekt-lib.effektBackends; [ js ];
      in {
        packages.default = effekt-lib.buildEffektPackage {
          pname = "effekt-template";       # Package name
          version = "0.1.0";               # Package version
          src = ./.;                       # Source folder
          main = "src/main.effekt";        # relative path to entrypoint (as a string)
          tests = [ "src/mytest.effekt" ]; # relative paths to tests (as a string)

          inherit effektVersion backends;
        };

        devShells.default = effekt-lib.mkDevShell {
          inherit effektVersion backends;
        };
      }
    );
}
