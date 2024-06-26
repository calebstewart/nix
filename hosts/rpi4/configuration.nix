{inputs, user, ...}: {
  imports = [
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
  ];

  config = {
    modules = {
      users.enable = true;
      nh.enable = true;
      sshd.enable = true;
      # containers.enable = true;
      # containers.dockerCompat = true;
    };

    # Set the initial password for the user to "raspberry" for our raspberry pi
    users.users.${user.name}.initialPassword = "raspberry";

    networking = {
      useDHCP = false;
      useNetworkd = true;
      dhcpcd.enable = false;

      wireless = {
        enable = true;
      };
    };

    # Use systemd-networkd for network management
    systemd.network = {
      enable = true;

      networks = {
        # Setup wifi w/ DHCP
        "10-wifi" = {
          matchConfig.Name = "wlan0";
          networkConfig.DHCP = "ipv4";
        };
      };
    };

  };
}
