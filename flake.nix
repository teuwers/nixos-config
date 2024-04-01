{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
  };

  outputs = {
    self
    , nixpkgs
    , home-manager
    , nur
  }@inputs: {
    nixosConfigurations = {
      mike-notebook = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/notebook.nix
          inputs.home-manager.nixosModules.home-manager
        ];
      };
      mike-desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/desktop.nix
        ];
      };
    };
  };
}
