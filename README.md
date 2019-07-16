# Usage

Clone this repository to your home directory for example.
Before the first run you must fetch the latest **home-manager** repo metadata.

```bash
./path/to/local/checkout/update.sh
```

Then replace the content of your configuration file with:

```nix
# /etc/nixos/configuration.nix
import /path/to/local/checkout/hosts/clevo-N141ZU
```

Here, **clevo-N141ZU** corresponds to an entry in the **hosts** folder.
This is the entry point which applies machine specific configuration and then loads the rest of the configuration.

The current configuration uses the **EXWM window manager** which expects some files in your **~/.emacs.d** directory.
You can see some example on [my emacs configuration](https://github.com/aveltras/.emacs.d).
