{ stdenv, fetchFromGitHub, cmake, pkgconfig, rtl-sdr, libusb }:

stdenv.mkDerivation rec {
  pname = "rtl_433";
  version = "22.11";

  src = fetchFromGitHub {
    owner = "merbanan";
    repo = pname;
    rev = version;
    hash = "sha256-qDY+prdf8O/dqmAgLU6lpsNIvL1R5V2AwsB+4CpOqGM=";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ rtl-sdr libusb ];
}
