{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
  };

  outputs = { self, nixpkgs }: let
    inherit (nixpkgs.lib) elemAt filterAttrs length;
  in {
    removeKey = set: x: removeAttrs set [ x ];
    mapAccumL = f: e: xs: let
      stop = builtins.length xs;
      go = results: state: n:
        if n == stop then
          { inherit state results; }
        else let
          p = f state (elemAt xs n);
        in go (results ++ [ p.result ]) p.state (n + 1);
    in go [ ] e 0;
  };
}
