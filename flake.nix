{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    haskell-flake.url = "github:srid/haskell-flake";
  };
  outputs = inputs@{ self, nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.systems.flakeExposed;
      imports = [ inputs.haskell-flake.flakeModule ];

      perSystem = { self', pkgs, ... }:
        {

          haskellProjects.default = {
            packages = { };
            settings = { };

            devShell = {
              # Enabled by default
              # enable = true;

              # Programs you want to make available in the shell.
              # Default programs can be disabled by setting to 'null'
              # tools = hp: { fourmolu = hp.fourmolu; ghcid = null; };
            };
          };

          # haskell-flake doesn't set the default package, but you can do it here.
          packages.default = self'.packages.problem;
        };
    };
}
