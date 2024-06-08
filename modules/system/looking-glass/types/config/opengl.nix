{lib, typeYesNo, ...}: {
  options = {
    mipmap = lib.mkOption {
      description = "Enable mipmapping";
      default = "yes";
      type = typeYesNo;
    };

    vsync = lib.mkOption {
      description = "Enable vsync";
      default = "no";
      type = typeYesNo;
    };

    preventBuffer = lib.mkOption {
      description = "Prevent the driver from buffering frames";
      default = "yes";
      type = typeYesNo;
    };

    amdPinnedMem = lib.mkOption {
      description = "Use GL_AMD_pinned_memory if it is available";
      default = "yes";
      type = typeYesNo;
    };
  };
}
