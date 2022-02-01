{ stdenv, fetchFromGitHub }:
{
  sddm-slice = stdenv.mkDerivation rec {
    pname = "sddm-slice";
    version = "1.5.1";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src $out/share/sddm/themes/sddm-slice
    '';
    src = fetchFromGitHub {
      owner = "RadRussianRus";
      repo = "sddm-slice";
      rev = "v${version}";
#      sha256 = "0gx0am7vq1ywaw2rm1p015x90b75ccqxnb1sz3wy8yjl27v82yhb";
    };
  };
}
