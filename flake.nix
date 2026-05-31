{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    bundix = {
      url = "github:inscapist/bundix/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ruby-nix = {
      url = "github:inscapist/ruby-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    bundix,
    ruby-nix,
    nix-ld
  }: let
    system = "x86_64-linux";

    modules = [
      nix-ld.nixosModules.nix-ld
      { programs.nix-ld.dev.enable = true; }
    ];

    pkgs = import nixpkgs {
      inherit system;
      overlays = [ ruby-nix.overlays.ruby ];
    };
    rubyNix = ruby-nix.lib pkgs;
		bundixcli = bundix.packages.${system}.default;

    deps = with pkgs; [ env ruby bundixcli openssl_4_0 ];

    inherit (rubyNix {
      name = "seroperson.gitlab.io";
      gemset = ./gemset.nix;
      gemConfig = pkgs.defaultGemConfig;
    })
      env ruby;
  in {
    packages.${system} = let
      bundlecli = pkgs.writeShellApplication {
        name = "bundle";
        runtimeInputs = deps;
        text = ''
          export BUNDLE_PATH=vendor/bundle
          bundle "$@"
        '';
      };
      jekyll = pkgs.writeShellApplication {
        name = "jekyll";
        runtimeInputs = deps;
        text = ''
          if [ $# -eq 0 ]; then
            jekyll build
          else
            jekyll "$@"
          fi
        '';
      };
    in {
      jekyll = jekyll;
      bundle = bundlecli;
      bundix = bundixcli;
      default = jekyll;
    };

    devShells.${system}.default = pkgs.mkShell {
      shellHook = ''
        export BUNDLE_PATH=vendor/bundle
      '';
      buildInputs = deps;
    };
  };
}