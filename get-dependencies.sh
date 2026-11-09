#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
  base-devel                  \
  bash                        \
  curl                        \
  dbus                        \
  desktop-file-utils          \
  diffutils                   \
  freetype2                   \
  gdk-pixbuf2                 \
  glibc                       \
  hicolor-icon-theme          \
  libgcc                      \
  libxcrypt                   \
  libxcrypt-compat            \
  lsb-release                 \
  lsof                        \
  nss                         \
  python                      \
  python-cbor2                \
  python-pyzstd               \
  python-urllib3              \
  python-xlib                 \
  python-xxhash               \
  ttf-dejavu                  \
  vulkan-icd-loader           \
  xdg-user-dirs               \
  xorg-xrandr                 \
  python-truststore           \
  rust                        \
  git                         \
  python-build                \
  python-setuptools           \
  python-setuptools-scm       \
  python-wheel                \
  python-hatchling            \
  python-hatch-vcs            \
  python-installer            \
  python-maturin              \
  python-pip                  \
  scdoc

  # lib32-alsa-plugins          \
  # lib32-gcc-libs              \
  # lib32-glibc                 \
  # lib32-libglvnd              \
  # lib32-libgpg-error          \
  # lib32-libx11                \
  # lib32-libxcrypt             \
  # lib32-libxcrypt-compat      \
  # lib32-libxss                \
  # lib32-nss                   \
  # lib32-vulkan-icd-loader     \

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
make-aur-package zenity-rs-bin

# If the application needs to be manually built that has to be done down here

PIP_BREAK_SYSTEM_PACKAGES=1 pip install --upgrade "setuptools-scm<10"
git clone --recurse-submodules https://github.com/Open-Wine-Components/umu-launcher ./umu-launcher

(
  cd ./umu-launcher
  
  git fetch --tags origin
  TAG=$(git tag --sort=-v:refname | grep -vi 'rc\|alpha\|beta' | head -1)
  git checkout "$TAG"
  echo "${TAG#v}" > ~/version  
  ./configure.sh --prefix=/usr
  make
  make install  
)
