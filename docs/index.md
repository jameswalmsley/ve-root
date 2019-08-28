# VE-ROOT

VE-ROOT is an embedded rootfs build tool.

# Repository

| Location   | Description                                         |
| ---------- | --------------------------------------------------- |
| `Makefile` | top-level ve-root Makefile                          |
| `mk/*.mk`  | Internal ve-root scripts, e.g. $(DEFINE_RECIPE) ... |
| `docs`     | Documentation.                                      |
| `configs`  | A cache of defconfig files.                         |
| `layers`   | Generic layers for use in recipes.                  |
| `recipes`  | Build recipes.                                      |
| `sources`  | Source checkout folder                              |
| `out`      | Build output folder.                                |

# Build System

The build system works using a structure of recipes, built from layers, containing tasks.

* A recipe describes how to build an entire system - an ordered list of layers.
* Layers within the recipe describe how to build each 'component'.
* Each layer consists of many 'Make' tasks to generate the layer outputs.

The dependency graph is managed at the layer level.
Layers are responsible for managing their own internal dependencies.

```note
It is highly recommend to remain within the recipe/layer model. Deviating from
this design pattern will result in unreliable builds and difficult dependency issues.
```

!!NOTE!! Before building any recipe, complete a source-checkout first:

```
make -j4 source-checkout
```

Some recipes may rely on source code (e.g. git revisions etc) to generate internal variables.

# Recipes

## Variants
Recipe configurations can define multiple variants.
To define a variant simply define CONFIG_VARIANT in a config file:

```
CONFIG_VARIANT:=jetson-tx2
```

Defining a variant will ensure that all sources, and build outputs are kept separate from each other.
This allows easy switching between configurations and prevents 'stale' or mixed builds.

## Layers

# Source Code Management

Layers define all the sources they require using the git_clone and get_archive functions.

| Function    | Example                                                  | Description                      |
| ----------- | -------------------------------------------------------- | -------------------------------- |
| git_clone   | $(call git_clone, checkout-dir, git-url, tag/branch/ref) | Clones a git repo.               |
| get_archive | $(call get_archive, checkout-dir, url)                   | Fetches and extracts an archive. |

These will be cloned and downloaded using `make source-checkout`.

## Checkout Path

```
sources/$(RECIPE)/{$(VARIANT)}/L_$(LAYER)/checkout-dir
```

Individual tasks can access the sources through the variables:

```
$(srcdir)/checkout-dir          # Task context only (runtime).
$(SRC_layer-name)/checkout-dir  # Globally
```

# Build Management

Similar to source management, all builds are found under:

```
OUT:=out/$(RECIPE)/{$(VARIANT)}/
$(OUT)/build/L_$(LAYER)/
$(OUT)/rootfs
...
```

A layer's build path is accessible through the following variables:

```
$(builddir)/
$(BUILD_layer-name)/
```

# Commands

| Command                     | Description                                  |
| --------------------------- | -------------------------------------------- |
| `make info`                 | List all layers in the configured recipe.    |
| `make source-checkout`      | Clone and download all sources.              |
| `make docker`               | Enter the docker container.                  |
| `make docker.build`         | Build the configured docker container.       |
| `make chroot`               | Enter a chroot jail of the generated rootfs. |
| `make git.pull`             |                                              |
| `make git.checkout`         |                                              |
| `make git.fetch`            |                                              |
| `make git.submodule.update` |                                              |
| `make git.unshallow`        |                                              |
| `make git.rev-parse.head`   |                                              |
| `make git.status`           |                                              |
|                             |                                              |


# Variables

| Name                | Default                   | Context   | Description                                |
| ------------------- | ------------------------- | --------- | ------------------------------------------ |
| $(L)                | `$(LAYER)`                | Parse     |                                            |
| $(RECIPE)           | `recipes/recipe_name`     |           | The actual RECIPE the layer is defined in. |
| $(TOP)              | `recipes/top_recipe_name` |           | The absolute TOP layer.                    |
| $(BUILD)            | `$(OUT)/build`            |           |                                            |
| $(builddir)         | `$(BUILD)/$(L)`           | Make task | Equivalent to $(BUILD)/$(L)/               |
| $(BUILD_layer-name) | `$(BUILD)/layer-name`     | Global    |                                            |



## Layer Commands

## Layer Variables
LAYER:
LAYER_NODEPEND_FILE:


# Template System

