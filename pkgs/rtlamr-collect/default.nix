{ buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "rtlamr-collect";
  version = "1.0.3";
  goPackagePath = "github.com/bemasher/rtlamr-collect";
  src = fetchFromGitHub {
    owner = "bemasher";
    repo = pname;
    rev = "v${version}";
    sha256 = "16p0bgrdlc49jz424mfjqh1bj5f51ap3nmz1v2kfl4qmwg8y1rzd";
  };
  goDeps = ./deps.nix;
}
