{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    nativeBuildInputs = with pkgs.buildPackages; [ ruby jekyll bundler gcc openssl_4_0 ];
}
