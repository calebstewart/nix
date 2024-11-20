{
  autoPatchelfHook,
  buildFHSEnvChroot,
  dpkg,
  fetchurl,
  lib,
  stdenv,
  sysctl,
  iptables,
  iproute2,
  procps,
  cacert,
  libxml2,
  libidn2,
  libcap_ng,
  libnl,
  zlib,
  wireguard-tools,
  writeShellScript,
}: let
  pname = "nordvpn";
  version = "3.19.1";

  basePkg = stdenv.mkDerivation {
    inherit pname version;

    src = fetchurl {
      url = "https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/n/nordvpn/nordvpn_${version}_amd64.deb";
      hash = "sha256-SZERY2dLN4KhwatZtIAc63Qj/iyF3U+YVftEBUNYRWk=";
    };

    buildInputs = [libxml2 libidn2 libnl libcap_ng];
    nativeBuildInputs = [dpkg autoPatchelfHook stdenv.cc.cc.lib];
    dontConfigure = true;
    dontBuild = true;

    unpackPhase = ''
      runHook preUnpack
      dpkg --extract $src .
      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      mv usr/* $out/
      mv var/ $out/
      mv etc/ $out/
      runHook postInstall
    '';
  };

  preStart = writeShellScript "nordvpnd-pre-start" ''
    mkdir -m 700 -p /var/lib/nordvpn
    if [ -z "$(ls -A /var/lib/nordvpn)" ]; then
      cp -r ${basePkg}/var/lib/nordvpn/* /var/lib/nordvpn
    fi
  '';

  fhsPkg = buildFHSEnvChroot {
    name = "nordvpnd";
    runScript = "nordvpnd";

    targetPkgs = pkgs: [
      basePkg
      sysctl
      iptables
      iproute2
      procps
      cacert
      libxml2
      libidn2
      libnl
      libcap_ng
      zlib
      wireguard-tools
    ];
  };
in stdenv.mkDerivation {
  inherit pname version;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share

    ln -s ${basePkg}/bin/nordvpn $out/bin
    ln -s ${fhsPkg}/bin/nordvpnd $out/bin
    ln -s ${preStart} $out/bin/nordvpnd-pre-start
    ln -s ${basePkg}/share/* $out/share
    ln -s ${basePkg}/var $out/
    runHook postInstall
  '';

  meta = with lib; {
    description = "NordVPN Client";
    homepage = "https://www.nordvpn.com";
    license = licenses.unfreeRedistributable;
    platforms = ["x86_64-linux"];
  };
}
