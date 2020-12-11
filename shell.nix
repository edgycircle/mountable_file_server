{
  pkgs ? import (fetchGit {
    url = https://github.com/NixOS/nixpkgs-channels;
    ref = "nixos-20.03";
  }) {},
  ruby ? pkgs.ruby_2_5,
  bundler ? pkgs.bundler.override { inherit ruby; }
}:

pkgs.mkShell {
  buildInputs = with pkgs; [
    ruby
    bundler
    git
    sqlite
    zlib
    phantomjs
    rubyPackages_2_5.nokogiri
    libiconv
  ];

  shellHook = ''
    mkdir -p .local-data/gems
    export GEM_HOME=$PWD/.local-data/gems
    export GEM_PATH=$GEM_HOME
  '';
}
