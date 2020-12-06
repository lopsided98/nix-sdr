{ buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "rtlamr-collect";
  version = "20200825-unstable";
  goPackagePath = "github.com/bemasher/rtlamr-collect";
  src = fetchFromGitHub {
    owner = "bemasher";
    repo = pname;
    rev = "5fd3e7602a359c05bed78fcb3eecb0642cfdce6e";
    sha256 = "0y75mvvdnkcld0bfqjl02i6qa5kw1y8mil069a7n6bzmghyk69fn";
  };
}
