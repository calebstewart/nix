{inputs, user, ...}: {
  imports = [
    "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
  ];

  config = {
    modules = {
      users.enable = true;
      nh.enable = true;
      sshd.enable = true;
      containers.enable = true;
      containers.dockerCompat = true;
    };

    # Set the initial password for the user to "raspberry" for our raspberry pi
    users.users.${user.name}.initialPassword = "raspberry";
  };
}
