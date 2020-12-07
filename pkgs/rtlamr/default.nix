{ buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "rtlamr";
  version = "0.9.2";
  goPackagePath = "github.com/bemasher/rtlamr";
  src = fetchFromGitHub {
    owner = "bemasher";
    repo = pname;
    rev = "v${version}";
    sha256 = "0jrj5m1h1kw48kmkkn78mwzsgqrjdkb0xv6k96ic3g2gj4yqw1sr";
  };
  goDeps = ./deps.nix;
}
