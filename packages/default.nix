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
      rev = "b8904e380ab2d90f809278c24e6016dc870a9bae";
      sha256 = "sha256-2eGPJ9/sO+cxVXgDd54IzkwIHkMtP6yGigE3GOw9IRc=";
    };

    vendorHash = "sha256-sx8FFNbJbObBXgC//fgX24izlRytCU9CXMHvXuAbTsU=";
  })
]
