{
  allowUnfree = true;
  packageOverrides = pkgs: rec {
    # Install via
    #   nix-env -iA nixos.dev-env
    dev-env = pkgs.buildEnv {
      name = "dev-env";
      paths = with pkgs; [
        gcc
        cmake
        gdb
        valgrind
        linuxPackages.perf
        jetbrains.clion

        nodejs
        yarn

        jdk13
        gradle
        jetbrains.idea-ultimate
      ];
    };
  };
}
