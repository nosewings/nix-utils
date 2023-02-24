{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-22.11";
    };
  };

  outputs = { self, nixpkgs }: let
    inherit (nixpkgs.lib) elemAt filterAttrs foldl' genList length min;
  in {
    concatAttrs = foldl' (e: x: e // x) { };
    isNull = x: x != null;
    mapAccumL = f: e: xs: let
      stop = builtins.length xs;
      go = results: state: n:
        if n == stop then
          { inherit state results; }
        else let
          p = f state (elemAt xs n);
        in go (results ++ [ p.result ]) p.state (n + 1);
    in go [ ] e 0;
    removeAttr = set: x: removeAttrs set [ x ];
    zipWith = f: xs: ys: genList (i: f (elemAt xs i) (elemAt ys i)) (min (length xs) (length ys));
  };
}
