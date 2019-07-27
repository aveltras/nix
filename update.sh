#!/usr/bin/env nix-shell
#! nix-shell -p nix-prefetch-git -i sh
nix-prefetch-git https://github.com/rycee/home-manager > ./home-manager.json
#nix-prefetch-git https://github.com/colemickens/nixpkgs-wayland > ./nixpkgs-wayland.json
