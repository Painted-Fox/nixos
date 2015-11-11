{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
  ];

  networking = {
    hostId = "4b52f689";
    hostName = "vox";
  };

  virtualisation = {
    virtualbox = {
      guest = {
        enable = true;
      };
    };
  };

  boot = {
    kernelModules = [ ];
    extraModulePackages = [ ];

    initrd = {
      availableKernelModules = [
        "ata_piix"
        "ohci_pci"
      ];

      luks = {
        devices = [{
          name = "nixos-root";
          device = "/dev/sda2";
          allowDiscards = true;
        }];
      };
    };

    zfs = {
      forceImportRoot = false;
      forceImportAll = false;
    };
  };

  fileSystems = {
    "/" = {
      device = "rpool/ROOT/nixos";
      fsType = "zfs";
    };

    "/home" = {
      device = "rpool/home";
      fsType = "zfs";
    };

    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "ext2";
    };

    # Caution: NixOS will crash on boot if there is no VirtualBox shared folder
    # with the device name here.
    "/vbox" = {
      fsType = "vboxsf";
      device = "share";
      options = "rw";
    };
  };

  swapDevices = [
    { device = "/dev/zvol/rpool/swap"; }
  ];

  nix = {
    maxJobs = 2;
  };
}
