{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nvf.url = "github:notashelf/nvf";
  };

  outputs = { nixpkgs, home-manager, nvf, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    customNeovim = nvf.lib.neovimConfiguration {
      inherit pkgs;
      modules = [ ./nvf-config.nix ];
    };

  in {
    packages.${system}.my-neovim = customNeovim.neovim;

    homeConfigurations.username = home-manager.lib.homeManagerConfiguration {
      modules = [
        {home.packages = [customNeovim.neovim];}
      ];
    };
  };
}
