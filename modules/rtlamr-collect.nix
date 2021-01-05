{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.rtlamr-collect;
in {
  options.services.rtlamr-collect = {
    enable = mkEnableOption "InfluxDB data aggregation for rtlamr";

    server = mkOption {
      type = types.str;
      default = "localhost:1234";
      description = "Address and port of rtl_tcp instance";
    };

    filterId = mkOption {
      type = types.commas;
      default = "";
      example = "56201115";
      description = ''
        Display only messages matching an ID in a comma-separated list of IDs.
      '';
    };

    extraRtlamrArgs = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Extra arguments to pass to rtlamr";
    };

    influxdb = {
      hostName = mkOption {
        type = types.str;
        description = "InfluxDB hostname";
      };

      database = mkOption {
        type = types.str;
        default = "rtlamr";
        description = "InfluxDB database";
      };

      user = mkOption {
        type = types.str;
        default = "rtlamr";
        description = "InfluxDB user";
      };

      password = mkOption {
        type = types.str;
        description = ''
          InfluxDB password. Will be stored in plain text in the Nix store.
        '';
      };

      clientCert = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "X.509 certificate for client authentication";
      };

      clientKey = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "X.509 private key for client authentication";
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      { assertion = cfg.influxdb.clientCert != null -> cfg.influxdb.clientKey != null &&
                    cfg.influxdb.clientKey != null -> cfg.influxdb.clientCert != null;
        message = ''
          services.rtlamr-collect.influxdb.clientCert and
          services.rtlamr-collect.influxdb.clientKey must both be provided to
          enable client certificate authentication.
        ''; }
    ];

    systemd.services.rtlamr-collect = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "exec";
        User = "rtlamr-collect";
        Group = "rtlamr-collect";
      };
      environment = with cfg.influxdb; {
        COLLECT_INFLUXDB_USER = user;
        COLLECT_INFLUXDB_PASS = password;
        COLLECT_INFLUXDB_HOSTNAME = hostName;
        COLLECT_INFLUXDB_DATABASE = database;
        COLLECT_INFLUXDB_CLIENT_CERT = clientCert;
        COLLECT_INFLUXDB_CLIENT_KEY = clientKey;
      } // optionalAttrs (clientCert != null) {
        # Assertion guarantees that both are provided
        COLLECT_INFLUXDB_CLIENT_CERT = clientCert;
        COLLECT_INFLUXDB_CLIENT_KEY = clientKey;
      };
      script = ''
        '${lib.escapeShellArg pkgs.rtlamr}/bin/rtlamr' \
          ${lib.optionalString (cfg.filterId != "") "-filterid=${lib.escapeShellArg cfg.filterId}"} \
          -server=${lib.escapeShellArg  cfg.server} \
          -format=json \
          -unique=true \
          ${lib.escapeShellArgs cfg.extraRtlamrArgs} | \
        ${lib.escapeShellArg pkgs.rtlamr-collect}/bin/rtlamr-collect
      '';
    };

    users = {
      users.rtlamr-collect = {
        description = "rtlamr-collect user";
        isSystemUser = true;
        group = "rtlamr-collect";
      };
      groups.rtlamr-collect = {};
    };
  };
}
