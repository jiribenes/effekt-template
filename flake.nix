{
  description = "Nix template for Effekt projects";

  inputs.effekt-nix.url = "github:jiribenes/effekt-nix";
  
  outputs = { self, nixpkgs, effekt-nix }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
      effekt-lib = effekt-nix.lib.${system};

      # You can set a fixed Effekt version and your supported backends here:
      effektVersion = "0.3.0";
      backends = with effekt-lib.effektBackends; [ js ];
    in {
      packages.${system}.default = effekt-lib.buildEffektPackage {
        pname = "effekt-template";   # Package name
        version = "0.1.0";           # Package version
        src = ./.;                 # Source folder
        main = "./src/main.effekt";        # relative path to entrypoint
        tests = [ "./src/mytest.effekt" ];   # relative paths to tests

        inherit effektVersion backends;
      };

      devShells.${system}.default = effekt-lib.mkDevShell {
        inherit effektVersion backends;
      };
    };
}
