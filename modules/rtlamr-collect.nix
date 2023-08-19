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

      token = mkOption {
        type = types.str;
        description = ''
          InfluxDB token with write access to bucket. When connecting to a v1.8
          instance, the token is of the form: username:password. Will be stored
          in plain text in the Nix store.
        '';
      };

      organization = mkOption {
        type = types.str;
        default = "";
        description = ''
          InfluxDB organization. When connecting to a v1.8 instance, provide an
          arbitrary value.
        '';
      };

      bucket = mkOption {
        type = types.str;
        description = ''
          InfluxDB bucket used to store data. When connecting to a v1.8
          instance, the bucket is of the form: database/retention_policy.
        '';
      };

      measurement = mkOption {
        type = types.str;
        default = "rtlamr";
        description = "InfluxDB measurement to use";
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
        Restart = "always";
        RestartSec = 10;
        StateDirectory = "rtlamr-collect";
        WorkingDirectory = "/var/lib/rtlamr-collect";
      };
      unitConfig = {
        StartLimitBurst = 5;
        StartLimitIntervalSec = 300;
      };
      environment = with cfg.influxdb; {
        COLLECT_INFLUXDB_HOSTNAME = hostName;
        COLLECT_INFLUXDB_TOKEN = token;
        COLLECT_INFLUXDB_ORG = organization;
        COLLECT_INFLUXDB_BUCKET = bucket;
        COLLECT_INFLUXDB_MEASUREMENT = measurement;
      } // optionalAttrs (clientCert != null) {
        # Assertion guarantees that both are provided
        COLLECT_INFLUXDB_CLIENT_CERT = clientCert;
        COLLECT_INFLUXDB_CLIENT_KEY = clientKey;
      };
      script = ''
        set -o pipefail
        ${lib.escapeShellArgs ([
         "${pkgs.rtlamr}/bin/rtlamr"
        ] ++ lib.optionals (cfg.filterId != "") [
          "-filterid" cfg.filterId
        ] ++ [
          "-server" cfg.server
          "-format=json"
          "-unique=true"
        ] ++ cfg.extraRtlamrArgs)} | \
        ${lib.escapeShellArg pkgs.rtlamr-collect}/bin/rtlamr-collect
      '';
    };

    users = {
      users.rtlamr-collect = {
        isSystemUser = true;
        group = "rtlamr-collect";
      };
      groups.rtlamr-collect = {};
    };
  };
}
