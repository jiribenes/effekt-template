# Effekt template

> [!WARNING]
> This is a work-in-progress.

## First Steps

You cloned the template, congratulations. Now it's time to do the following:
1. Change the name in the license in `LICENSE` (or change the license altogether).
2. Go to `flake.nix` and rename your project name. If needed, tweak the other values.
3. Clone this repository locally

### Useful commands

#### Run the main file
```sh
effekt src/main.effekt
```
uses the JavaScript backend to run the main file.

If you want a different backend, use the `--backend <backend>` flag.
Call `effekt --help` to see all of the backends

#### Run the tests

```sh
effekt src/test.effekt
```
uses the JavaScript backend to run the tests. See how to select a different backend above.

#### REPL

```sh
effekt
```
on its own just opens the REPL.

#### Build the project

```sh
# if `src/main.effekt` is the main entrypoint
effekt --build src/main.effekt
```
uses the JavaScript backend to build the project into `out/`. See how to select a different backend above.

As output, there should be a runnable file `out/main`.

#### Nix-related commands

There's no need to install Nix because of this template, but Nix does provide a few nice things:

```sh
# Update the dependencies (ran automatically on the CI)
nix flake update

# Open up a shell with all of the necessary dependencies, correct Effekt version, etc. without needing to install them.
nix develop

# Run the main entry point directly
nix run

# Build this project, the output is in `result/bin/`
nix build
```

## Example projects using this template

- [`effekt-stm`](https://github.com/jiribenes/effekt-stm)
- this very project, see Description of the repo below

## Description of the repo

TODO

- `src/` includes:
   - a `main.effekt` file serving as the main entry point
   - a `test.effekt` file serving as the main entry point for tests
   - a `lib.effekt` file which is imported in `main` and `test`

### CI

There are two GitHub Actions set-up:
- `flake-check` checks the `flake.nix` file, tries to build and test everything
    - runs on demand, on `main`, and on PRs
    - if you want to run something custom, add a step which:
        - use `nix run -- <args>` to run the main endpoint,
        - and/or `nix develop -c '<some bash command>'` to run whatever you want in the correct environment 
- `update-flake-lock` updates the versions of packages used in `flake.nix`
    - runs on demand and weekly every Monday at 06:00 UTC
