{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.rtl-tcp;
in {
  options.services.rtl-tcp = {
    enable = mkEnableOption "I/Q spectrum server for RTL2832 based DVB-T receivers";

    address = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "127.0.0.1";
      description = "Listen address";
    };

    port = mkOption {
      type = types.port;
      default = 1234;
      description = "Listen port";
    };

    deviceIndex = mkOption {
      type = types.ints.unsigned;
      default = 0;
      description = "Index of the RTL-SDR device";
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Extra arguments to pass to rtl_tcp";
    };
  };

  config = mkIf cfg.enable {
    hardware.rtl-sdr.enable = true;

    systemd.services.rtl-tcp = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "exec";
        User = "rtl-tcp";
        Group = "rtl-tcp";
        ExecStart = lib.escapeShellArgs ([
          "${pkgs.rtl-sdr}/bin/rtl_tcp"
          "-p" (toString cfg.port)
          "-d" (toString cfg.deviceIndex)
        ] ++ optional (cfg.address != null) cfg.address
          ++ cfg.extraArgs);
      };
    };

    users = {
      users.rtl-tcp = {
        isSystemUser = true;
        group = "rtl-tcp";
        # Allow access to RTL-SDR
        extraGroups = [ "plugdev" ];
      };
      groups.rtl-tcp = {};
    };
  };
}
