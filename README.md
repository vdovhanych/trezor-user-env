# Trezor User Env

This environment is meant to support Trezor development - both Firmware and Suite and other related projects. Its main goals are:

- Provide an easy websocket server that is capable of:
  - Launching/stopping different versions of the firmware emulator.
  - Launching/stopping trezord-go (Bridge).
  - Send simple debug commands to the emulator.
- Enable full integration testing of Suite, firmware emulator and Bridge using the websocket server.
- Provide a HTML page that communicates with the server. This allows the developers to perform the actions above.
- To be Nix-native but also offer Docker image to allow non-NixOS
developers to use it.

## How to run

_You can also run trezor-user-env "natively" if you are on NixOS but we mainly support the Docker way as described here._

### Linux

#### Prerequisites

You need:
- Docker (to run NixOS in a container).

#### Run it

1. Run in terminal: `xhost +`
2. Download the latest docker build: `docker-compose -f ./docker/compose.yml pull trezor-user-env-unix`
3. Run it: `docker-compose -f ./docker/compose.yml up trezor-user-env-unix`
4. Open http://localhost:21326.

For a future use you can omit the second step and run `up` (the third step) directly. **However, you will not have the latest master builds then!**

----

### MacOS

#### Prerequisites

You need:
- [Docker](https://docs.docker.com/docker-for-mac/install/) (to run NixOS in a container)
- [XQuartz](https://www.xquartz.org/) (to share your screen with Docker)

Download these as you are used to. We recommend using `nix` or `brew`, but that's your fight.

#### Run it for Intel Mac

1. Run XQuartz and leave it running on the background. Wait till it is launched.
2. In XQuartz settings go to Preferences > Security and enable "Allow connections from network clients".
3. Open a new terminal window (not in XQuartz) and add yourself to the X access control list: `xhost +127.0.0.1` (you will probably need to logout/login after XQuartz installation to have `xhost` command available)
4. Download the latest docker build: `docker-compose -f ./docker/compose.yml pull trezor-user-env-mac`
5. Run it: `docker-compose -f ./docker/compose.yml up trezor-user-env-mac`
6. Open http://localhost:21326.

For a future use you can omit the second step and run `up` (the third step) directly. **However, you will not have the latest master builds then!**

#### Run it for Apple Silicon (M1) Mac

1. Run XQuartz and leave it running on the background. Wait till it is launched.
2. In XQuartz settings go to Preferences > Security and enable "Allow connections from network clients".
3. Open a new terminal window (not in XQuartz) and add yourself to the X access control list: `xhost +127.0.0.1` (you will probably need to logout/login after XQuartz installation to have `xhost` command available)
4. Build docker image locally for ARM using buildx `docker buildx build -t trezor-user-env-arm.mac . -f ./docker/arm-docker/Dockerfile --load`
5. TODO: Download the latest docker build: `docker-compose -f ./docker/compose.yml pull trezor-user-env-mac`
6. TODO: Run it: `docker-compose -f ./docker/compose.yml up trezor-user-env-arm-mac`
7. Open http://localhost:21326.

For a future use you can omit the second step and run `up` (the third step) directly. **However, you will not have the latest master builds then!**

----

### Windows

Currently not supported, but should work using docker as well.

## How to develop

In case you need to modify something in trezor-user-env you have two options.

### Natively in NixOS

If you are using NixOS you can do the changes locally and then run the controller yourself. Run it via `nix-shell controller/shell.nix --run 'python controller/main.py'`. Make sure you have run `{firmware,suite,trezord-go}/bin/download.sh` beforehand otherwise you'll have old binaries.

This is suitable for smaller changes or things you can check via the HTML dashboard easily. However, if you are adding some functionality to trezor-user-env mainly because of Suite end-to-end tests, it is probably better to go the CI way (below). Otherwise you would need to run the whole Suite test suite locally.

### Let CI do it

The simpler but less flexible way is to let the [CI](https://gitlab.com/satoshilabs/trezor/trezor-user-env/pipelines) build it. You can create a branch, commit your changes and then push them. The CI will build it for you and tag the appropriate docker image as `test`. You can then modify all scripts/commands and use `registry.gitlab.com/satoshilabs/trezor/trezor-user-env/trezor-user-env:test` instead of `registry.gitlab.com/satoshilabs/trezor/trezor-user-env/trezor-user-env` which defaults to the `latest` tag which equals trezor-user-env's master. Suite's docker-compose files in the `docker` subdirectory are the place where you want to change this.
