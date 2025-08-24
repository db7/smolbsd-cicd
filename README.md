# Simple CICD container with smolBSD

This repository is an example of how to use [smolBSD](https://smolbsd.org) as
a container in a CICD pipeline. Since smolBSD can boot very quickly, it is a
good tool to run tests cases without booting a heavy-weight VM.

The idea is simple. It consists of these phases:

## 1. creating a Docker container

The steps below are in `.github/workflows/docker.yml`. The workflow is
triggered manually.

### 1.1 Create the VM image

Starting with a Ubuntu, install the dependencies for smolBSD:

    sudo apt install -y \
       build-essential  \
       curl             \
       git              \
       libarchive-tools \
       rsync            \
       uuid-runtime

Next, get smolBSD and sets and kernel (`scripts/get_smolBSD.sh`):

    git clone --depth 1 https://github.com/NetBSDfr/smolBSD.git smolBSD
    cd smolBSD
    curl -LO https://smolbsd.org/assets/netbsd-SMOL
    gmake setfetch SETS="base.tar.xz etc.tar.xz comp.tar.xz"

Our project may need some tools beyond those in comp set, for example, cmake.
The script `scripts/get_pkgsrc.sh` will download with `curl` the given packages
and their dependencies from [pkgsrc](https://pkgsrc.org):

    scripts/get_pkgsrc.sh cmake

Finally, create the VM image using smolBSD script `mkimg.sh`:

    cd smolBSD
    PKGS="../pkgsrc/downloads/*.tgz"
    sudo env ADDONS="$PKGS" ./mkimg.sh -s base -i smolbsd.img \
            -x "base.tar.xz etc.tar.xz comp.tar.xz" \
            -m 2048

### 1.2 Save the VM image in a Docker container image

Build a Docker image with the `Dockerfile` in the repo. It will install smolBSD
and copy the generated `smolbsd.img` into `/data/smolBSD/`.

After that,  push the Docker image to the CICD registry.

## 2. Running the tests

Whenever code changes in our example project are pushed, we'd like to test them
running the following steps in a Docker container from the previous phase check
`.github/workflows/example.yml` for details).

1. `scripts/add2img.sh <SMOLBSD_IMAGE> <PATH_TO_CODE>`: add the repository with
   the test and code to the smolBSD image. Here, our test is in `example/`. The
   script that starts the test is inside `add2img.sh`.
2. Using `smolBSD/startnb.sh`, run test(s) in QEMU. Ensure the test results are
   saved to the VM disk. Important: pass option `-x "-no-reboot"` to stop QEMU
   when the test is done.
3. `scripts/get_results.h <SMOLBSD_IMAGE>`: open the image and check the results
   of the test.

# Disclaimer

The code in this repo is a crude demo and has lots of room for improvement. For
example, the script defining the build and test steps is hardcoded inside
`scripts/add2img.sh`.  Instead of storing the image inside a Docker container,
one can store that as a GitHub release file. That can be downloaded and mounted
on demand. Also, one can use cross-platform-actions instead of running with
Docker.

