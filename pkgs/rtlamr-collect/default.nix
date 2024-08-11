{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "rtlamr-collect";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "bemasher";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-7efg0eMVE+qm2OFXO64KxRW5AsTSVSLIl4kw2vJb4Jo=";
  };

  vendorHash = "sha256-aUuKZaE31PSxJSvvJ+Ag0LXNewYLAC3nuuDV9sLUpJU=";

  meta = with lib; {
    description = "Data aggregation for rtlamr";
    homepage = "https://github.com/bemasher/rtlamr-collect";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ lopsided98 ];
  };
}
