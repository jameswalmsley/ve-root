# VE-ROOT

VE-ROOT is an embedded rootfs build tool.

## Commands

* `make info` - List all layers in the configured recipe.
* `make git.pull` - Pull all git repos from all layers.

## Build Output

    mkdocs.yml    # The configuration file.
    docs/
        index.md  # The documentation homepage.
        ...       # Other markdown pages, images and other files.

## Variables

| Name        | Default             | Context | Description            |
| ----------- | ------------------- | ------- | ---------------------- |
| $(L)        | Current layer name. | Parse   |                        |
| $(RECIPE)   |                     |         |                        |
| $(BUILD)    |                     |         |                        |
| $(builddir) |                     | Runtime | Equivalent to $(BUILD) |


## Layer Commands

