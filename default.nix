{
  pkgs ? let
    lock = (builtins.fromJSON (builtins.readFile ./flake.lock)).nodes.nixpkgs.locked;
    nixpkgs = fetchTarball {
      url = "https://github.com/nixos/nixpkgs/archive/${lock.rev}.tar.gz";
      sha256 = lock.narHash;
    };
  in
    import nixpkgs {overlays = [];},
  ...
}: let
  # Helpful functions
  inherit (pkgs) lib;
in
  pkgs.stdenv.mkDerivation rec {
    pname = "registry";
    version = "0.0.2";

    src = ./src;

    preBuild = ''
      shellcheck ./generate-current
      shellcheck ./generate-versions
      shellcheck ./versions
      shellcheck ./generate
    '';

    buildPhase = ''
      patchShebangs .
    '';

    nativeBuildInputs = with pkgs; [
      shellcheck
    ];

    installPhase = ''
      install -Dv generate-current $out/bin/generate-current
      install -Dv generate-versions $out/bin/generate-versions
      install -Dv versions $out/bin/versions
      install -Dv generate $out/bin/generate
    '';

    meta = with lib; {
      homepage = "https://github.com/xinux-org/registry";
      description = "Nix registry for extracting easy json data.";
      licencse = licenses.mit;
      platforms = with platforms; linux ++ darwin;
      mainProgram = "generate";
      maintainers = with maintainers; [orzklv];
    };
  }
