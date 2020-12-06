{
  description = "Common software defined radio (SDR) related packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    with flake-utils.lib;
    eachSystem allSystems (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ self.overlay ];
      };
    in {
      packages = {
        inherit (pkgs)
          rtlamr
          rtlamr-collect
          rtl-433
          sdrtrunk;
      };
    }) // {
      overlay = import ./overlay.nix;
    };
}
