{ stdenv, fetchFromGitHub, cmake, pkgconfig, rtl-sdr, libusb }:

stdenv.mkDerivation rec {
  pname = "rtl_433";
  version = "20.11";

  src = fetchFromGitHub {
    owner = "merbanan";
    repo = pname;
    rev = version;
    sha256 = "093bxjxkg7yf78wqj5gpijbfa2p05ny09qqsj84kzi1svnzsa369";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ rtl-sdr libusb ];
}
