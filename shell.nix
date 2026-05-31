{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    nativeBuildInputs = with pkgs.buildPackages; [ ruby_4_0 jekyll bundler gcc openssl_4_0 ];
}
