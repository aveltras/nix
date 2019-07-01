# Usage

On the first run, you'll have to use this command to fetch the latest info for the necessary github repos:

```bash
sudo -- sh -c 'nix-prefetch-git https://github.com/aveltras/nix > /etc/nixos/nix.json; nix-prefetch-git https://github.com/rycee/home-manager > /etc/nixos/home-manager.json'
```
Once configured via this repo, the shell alias **update-nix** will do the same.

Next, switch the content of your **/etc/nixos/configuration.nix** to:

```nix
let thunk = builtins.fromJSON (builtins.readFile /etc/nixos/nix.json);
in import (builtins.fetchTarball {
     url = "https://github.com/aveltras/nix/archive/${thunk.rev}.tar.gz";
     sha256 = thunk.sha256;
   }) "clevo-N141ZU"
```

The last argument (here **clevo-N141ZU**) should correspond to a physical machine specific configuration file in the "hosts" directory.
