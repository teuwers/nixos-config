{ stdenv, lib, ... }:

with lib;

stdenv.mkDerivation rec {
  name = "${package-name}-${version}";
  package-name = "pointinghand-white-xcursor-theme";
  version = "1.0";
  nativeBuildInputs = [ unzip ];
  buildInputs = [ unzip ];

  src = PointingHand-White.zip;

  installPhase = ''
    for theme in ${concatStringsSep " " variants}; do
      mkdir -p $out/share/icons/$theme
      cp -R $theme/{cursors,index.theme} $out/share/icons/$theme/
    done
  '';

  meta = {
    description = "Pointing Hand White cursor theme";
    homepage = https://wayback.pling.com/s/Gnome/p/999710/;
    platforms = platforms.all;
  };
}