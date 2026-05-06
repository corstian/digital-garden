---
title: "Factorio headless on NixOS without space-age, quality and elevated-rails mods"
date: 2026-05-05
toc: false
---

Running a headless factorio on NixOS is easy. That works somewhere along the lines of this:

```nix
services.factorio = {
  enable = true;
  openFirewall = true;
  lan = true;
};
```

Running with mods is slightly more difficult. Seemingly the best approach is copying mods into your nix configuration and adding the following snippet ([source](https://wiki.nixos.org/wiki/Factorio#Mods)):

```nix
services.factorio.mods =
  let
    inherit (pkgs) lib;
    modDir = ./factorio-mods;
    modList = lib.pipe modDir [
      builtins.readDir
      (lib.filterAttrs (k: v: v == "regular"))
      (lib.mapAttrsToList (k: v: k))
      (builtins.filter (lib.hasSuffix ".zip"))
    ];
    modToDrv = modFileName:
      pkgs.runCommand "copy-factorio-mods" {} ''
        mkdir $out
        cp ${modDir + "/${modFileName}"} $out/${modFileName}
      ''
      // { deps = []; };
    in
    builtins.map modToDrv modList;
```

What happens then is that by default, in addition to the mods you added to the `./factorio-mods` directory, the factorio client also attempts to load the space-age, quality and elevated-rails mods.

The reason for this is that these mods are included in the headless version of the game by default. To remove these the most straightforward way is to create a local override of the `factorio-headless` package removing these directories. This can be done declaratively using nix as follows:

```nix
services.factorio.package = (pkgs.factorio-headless.overrideAttrs (oldAttrs: {
      installPhase = (oldAttrs.installPhase or "") + ''
        rm -rf "$out/share/factorio/data/space-age"
        rm -rf "$out/share/factorio/data/quality"
        rm -rf "$out/share/factorio/data/elevated-rails"
      '';
    }));
```

Happy factory building!