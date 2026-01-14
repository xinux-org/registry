flake: {pkgs, ...}: let
  system = pkgs.hostPlatform.system;
  base = flake.packages.${system}.default;
in
  pkgs.mkShell {
    inputsFrom = [base];

    packages = with pkgs; [
      nixd
      statix
      deadnix
      alejandra

      shfmt
      bash-language-server

      coreutils
      findutils
      gawk
      git
      gnugrep
      gnused
      jq
      recode
      util-linux
    ];

    shellHook = ''
      rm -rf result
    '';
  }
