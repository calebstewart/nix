# Generic packages for any system type
{pkgs, lib, ...}: with pkgs; [
  slack
  zoom-us
  spotify
  zip
  unzip
  file
  awscli2
  aws-vault
  ssm-session-manager-plugin
  audacity
  nix-output-monitor
  gcc

  (pkgs.buildGoModule {
    pname = "spacectl";
    version = "0.0.1";

    src = pkgs.fetchFromGitHub {
      owner = "calebstewart";
      repo = "spacectl";
      rev = "9f90069553c5978f8c9215784ac5564695ea5d8d";
      sha256 = "sha256-wIHULPcOwutzIw5oyykXjrr9mPoycTZ2JSg+w/44kOk=";
    };

    vendorHash = "sha256-H6oIJlgqo8q+LcbmoK3vAp+lOqHWyscFH3uxMvLyT+Q=";
  })
]
