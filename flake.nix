{
  description = "A nix flake whose legacyPackages contains every redistributable package";

  outputs = { self, nixpkgs }:

    let
      systems = [
        "x86_64-linux"
        "i686-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "armv6l-linux"
        "armv7l-linux"
      ];

      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
    in

    {
      legacyPackages = forAllSystems (system: import nixpkgs {
        inherit system;
        config = {
          allowUnfreePredicate = x: if x ? meta.license then x.meta.license.redistributable else false;
        };
      });
    };
}
