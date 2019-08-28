# Templates

The VE-ROOT system uses the jinja2 (python) based templating system.

`https://jinja.palletsprojects.com/en/2.10.x/`

The template driver is implemented under:

`layers/debian/.scripts/rootfspatch/generate.py`

## Global Variables

The following global variables are imported into the template context:

| Variable | Description            |
| -------- | ---------------------- |
| int      | Python int()           |
| hex      | Python hex()           |
| config   | Json config structure. |
| os       | Python os (import os)  |
| distro   | config['distro']       |
| system   | config['system']       |

# Examples

The best example is probably the boot init script:

```
layers/debian/bootramfs/ramdisk/bootinit.sh
```

The output can be found under:

```
out/build/L_debian-bootramfs/ramdisk/bootinit.sh
```
