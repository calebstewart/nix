{lib, typeYesNo, ...}: {
  options = {
    warpSupport = lib.mkOption {
      description = "Enable cursor warping";
      default = "yes";
      type = typeYesNo;
    };

    fractionScale = lib.mkOption {
      description = "Enable fractional scale";
      default = "yes";
      type = typeYesNo;
    };
  };
}
