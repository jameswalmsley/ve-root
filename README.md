```
ve-root - An embedded rootfs build tool.

Copyright (C) 2019  Vital Element Solutions Ltd <james@vitalelement.co.uk>

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
```

# VE-ROOT

VE-ROOT is an embedded rootfs build tool.

# Build System

The build system works on a pattern of recipes -> layers and tasks.

* A recipe describes how to build an entire system.
* A recipe includes/selects layers that make up the system.
* Each layer consists of many tasks to build up the layer.

Layers can depend on other layers completing.

The recipe/later model is very strict. Leaving this pattern will send you
into a wild goose chase around Make! :(

## Recipes


## Layers

Each layer represents a set of components, or configurations of the software/rootfs being built.
Layers can be cusomised by a recipe using variables, and configuration files in the $(RECIPE) dir.

The start of every layer begins with:

```make
LAYER:=layer-name
include $(DEFINE_LAYER)
```

This is followed by some definitions to define all targets, and dependencies for the layer.

Before the layer's make recipes are defined (tasks), the layer is hooked into the build system:

```make
include $(BUILD_LAYER)
```

Every layer can be triggered for building using:

```bash
make L_layername            # Trigger build of layername.
make L_layername.clean      # Trigger the layer's clean target.
make L_layername.invalidate # Deletes all outputs of a layer.
make L_layername.info       # Prints a list of layer targets and dependencies.
```


### Layer Dependencies

Every can specify build dependencies on other layers by appending to the DEPENDS variable:

DEPENDS += dependency-layer-name

Run order can also be defined using:

RUNAFTER += dependency-layer-name

The main advantage of RUNAFTER is you can serialise the build of different layers, without requiring
a rebuild of all subsequent layers. 

This is important to ensure a robust build where too much parralelism would cause an out-of-memory issue.

    NOTE:
    Layers may have dependencies between themselves. However tasks in one layer MUST NOT contain a dependency
    to a task in another layer.

    In such a case, dependency is created with a dependency to the required layer.

### Layer Serialisation

By default every layer is serialised in the recipe in the order in-which it is included in the recipe.
Parallelism can occur within a layer. Or is passed to e.g. a sub-make to build e.g. linux.

To pass parallelism to a sub-make use the $(MAKE) variable.

To enable parallel layers define:

    ENABLE_PARALLEL_LAYERS:=y

At the top of the recipe.mk file.

## Reserved Layer names:

| Layer      | Command           | Description                                       |
| ---------- | ----------------- | ------------------------------------------------- |
| bootloader | make L_bootloader | Builds any bootloader as specified by the recipe. |
| kernel     | make L_kernel     | Build the recipes kernel layer.                   |
| rootfs     | make L_rootfs     | Build the base rootfs.                            |
