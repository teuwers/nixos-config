{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    inputs.nur.url = github:nix-community/NUR;
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nur
  }: {
    nixosConfigurations = {
      mike-notebook = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/notebook.nix
        ];
      };
      mike-desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/desktop.nix
        ];
      };
    };
  };
}
