{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

stdenv.mkDerivation rec {
  pname = "dops";
  version = "1.18";

  src = fetchurl {
    url = "https://github.com/Mikescher/better-docker-ps/releases/download/v${version}/dops_linux-amd64";
    hash = "sha256-owA+oVTWSuKDRI+c7NjcY29g07/lkhaQSFR1+R05Y+A=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  # The upstream release is a binary, so there is no source archive to unpack.
  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp $src $out/bin/dops
    chmod +x $out/bin/dops

    runHook postInstall
  '';

  meta = {
    description = "A replacement for docker ps with more useful output";
    homepage = "https://github.com/Mikescher/better-docker-ps";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "dops";
  };
}
