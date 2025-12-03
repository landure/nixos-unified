inputs: rec {
  iego = import ./iego inputs;
  sunny = import ./sunny inputs;
  ghost = import ./ghost inputs;
  nixos = ghost;
}
