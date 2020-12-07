{ callPackage, fetchFromGitHub, gradleGen, java }:
let
  buildGradle = callPackage ./gradle-env.nix {
    gradleGen = gradleGen.override {
      java = java;
    };
  };
in buildGradle {
  envSpec = ./gradle-env.json;

  src = fetchFromGitHub {
    owner = "DSheirer";
    repo = "sdrtrunk";
    rev = "v0.4.0";
    sha256 = "15mqzn5mc5ir8wa4wgc403vw53r1jcfxfg5r34lrn50nvcm8jvyv";
  };

  gradleFlags = [ "installDist" ];

  installPhase = ''
    mv build/install/sdr-trunk "$out"
  '';
}
