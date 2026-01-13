{
  description = ''
    Vulnerable and unsafe citrix_workspace flake because citrix doesn't update their dependencies.

    This is fine.
    - Citrix, probably.
  '';

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-25-05.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-25-05,
  } @ inputs: {
    overlays.default = final: prev: let
      old = import nixpkgs-25-05 {
        system = prev.stdenv.hostPlatform.system or prev.system;
        config = {
          allowUnfree = true;
          permittedInsecurePackages = ["libsoup-2.74.3"];
        };
      };
    in {
      citrix_workspace = prev.citrix_workspace.overrideAttrs (oa: {
        buildInputs = (oa.buildInputs or []) ++ [old.webkitgtk_4_0];
        meta = (oa.meta or {}) // {broken = false;};
      });
    };
  };
}
