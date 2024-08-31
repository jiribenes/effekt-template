{
  description = "Nix template for Effekt projects";

  inputs.effekt-nix.url = "github:jiribenes/effekt-nix";
  
  outputs = { self, nixpkgs, effekt-nix }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
      effekt-lib = effekt-nix.lib.${system};

      # You can set a fixed Effekt version and your supported backends here:
      effektVersion = "0.2.2";
      backends = with effekt-lib.effektBackends; [ js llvm ];
    in {
      packages.${system}.default = effekt-lib.buildEffektPackage {
        pname = "effekt-template";   # Package name
        version = "0.1.0";           # Package version
        src = ./src;                 # Source folder
        main = ./main.effekt;        # relative path to entrypoint
        tests = [ ./test.effekt ];   # relative paths to tests

        inherit effektVersion backends;
      };

      devShells.${system}.default = effekt-lib.mkDevShell {
        inherit effektVersion backends;
      };
    };
}
