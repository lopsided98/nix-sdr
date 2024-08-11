{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "rtlamr";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "bemasher";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-0LufLU/wTmCRqTnQBNJg5UnDv0u1Thec5FSWATWqZsQ=";
  };

  vendorHash = "sha256-uT6zfsWgIot0EMNqwtwJNFXN/WaAyOGfcYJjuyOXT4g=";

  meta = with lib; {
    description = "An rtl-sdr receiver for Itron ERT compatible smart meters operating in the 900MHz ISM band.";
    homepage = "https://github.com/bemasher/rtlamr";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ lopsided98 ];
  };
}
