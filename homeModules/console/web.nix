/**
  # Web-related tools for the console.

  ## 🛠️ Tech Stack

  - [aerc @ sourcehut](https://sr.ht/~rjarry/aerc/).
  - [Chawan homepage](https://chawan.net/)
    ([Chawan @ sourcehut](https://sr.ht/~bptato/chawan/)).
  - [meli homepage](https://meli-email.org/)
    ([meli @ GitHub](https://github.com/meli/meli)).
  - [ddgr @ GitHub(https://github.com/jarun/ddgr).
  - [gomuks @ GitHub](https://github.com/gomuks/gomuks).
  - [irssi homepage](https://irssi.org/).
  - [monolith @ GitHub](https://github.com/Y2Z/monolith).
  - [readability-cli @ GitLab](https://gitlab.com/gardenappl/readability-cli).
  - [russ @ GitHub](https://github.com/ckampfe/russ).
  - [tuifeed @ GitHub](https://github.com/veeso/tuifeed).
  - [wiki-tui homepage](https://wiki-tui.net/latest/).

  ## 📝 Documentation

  - [programs.aerc @ Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.aerc.enable).
  - [programs.chawan @ Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.chawan.enable).
  - [programs.meli @ Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.meli.enable).

  ## 🙇 Acknowledgements

  - [Episode 619: The Trouble with TUIs @ Linux Unplugged](https://linuxunplugged.com/619)
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf mkDefault;

  cfg = config.biapy.nixos-unified.home-manager.console.web;
in
{
  options = {
    biapy.nixos-unified.home-manager.console.web = {
      enable = mkEnableOption "command-line web tools";
    };
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      curl
      ddgr # DuckDuckGo search CLI client
      # gomuks # Matrix client (requires insecure olm library)
      irssi # IRC terminal client
      monolith # Archiving a web page in a single HTML file
      readability-cli
      russ # RSS feed reader
      tuifeed # RSS feed reader
      wget
      wiki-tui # TUI for browsing Wikipedia
    ];

    programs = {
      # aerc is an email client for your terminal.
      aerc.enable = mkDefault true;
      # Chawan is a TUI web browser.
      chawan.enable = mkDefault true;
      # meli is an TUI email client.
      meli.enable = mkDefault true;
    };
  };
}
