{ buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "rtlamr-collect";
  version = "20201207-unstable";
  goPackagePath = "github.com/lopsided98/rtlamr-collect";
  src = fetchFromGitHub {
    owner = "bemasher";
    repo = pname;
    rev = "951451e459321f954aa237fa1b9e3c6c6b448239";
    sha256 = "119fpv2431dqp5px0hp56rxprhvmwi8prz5amk80ll8sk2p0y72s";
  };
}
