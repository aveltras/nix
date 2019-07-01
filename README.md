# Usage

Switch the content of your **/etc/nixos/configuration.nix** to :

```nix
import (builtins.fetchTarball https://github.com/aveltras/nix/archive/master.tar.gz) "clevo-N141ZU"
```

The last argument (here **clevo-N141ZU**) should correspond to a physical machine specific configuration file in the "hosts" directory.
