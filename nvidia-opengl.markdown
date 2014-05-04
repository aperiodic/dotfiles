# Installing NVIDIA OpenGL Drivers

In order to get a direct, hardware-accelerated OpenGL context in client applications, one needs to have
  - the discrete card enabled in BIOS;
  - the nvidia hardware drivers and client library installed;
  - the nvidia kernel modules loaded;
  - the X server configured to use the discrete card.

## BIOS

The BIOS setup is pretty straightforward; just hit Enter at boot, then hit F1 to enter BIOS setup, navigate to the "Config > Displays" page, and for the mode change it to "Discrete" (the others being "Integrated" and "Optimus").

## Drivers & Client Library

I'm not sure exactly which packages are involved here, but at the very minimum it's:
  * extra/nvidia (drivers)
  * extra/nvigia-libgl (client symlinks)
  * multilib/lib32-nvidia-libgl (32-bit client symlinks)

Bonus packages:
  * extra/libvdpau & multilib/lib32-libvdpau - hardware-accelerated video decoding
  * extra/nvidia-utils & multilib/lib32-nvidia-tuils - nvidia-settings application

## Kernel Modules

The `nvidia` kernel module should be loaded once rebooted after installing the `nvidia` package.

## XOrg Configuration

There's one at `etc/X11/xorg.conf.nvidia` from this file.

# Troubleshooting

In order to determine which OpenGL implementations the server and clients are using, run

```sh
glxinfo | egrep "glx (vendor|version)"
```

If they're different, then you won't be able to get a direct OpenGL context for applications.
