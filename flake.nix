{
    description = "LocalXpose CLI Binary";

    inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    outputs = { self, nixpkgs }: 
    let 
        platforms = {
            "x86_64-linux" = {
                url = "https://loclx-client.s3.amazonaws.com/loclx-linux-amd64.zip";
                sha256 = "sha256-jUUnX4u4OjAd5d3cipwxf8NMhCWwJqU+JbCaymSCCG0=";
            };
            "aarch64-linux" = {
                url = "https://loclx-client.s3.amazonaws.com/loclx-linux-arm64.zip";
                sha256 = "sha256-Ojg+OxWtq+N5+z9wEsXA+T6hCbdWBYpuohzYK87jNxI="; 
            };
        };

        forAllSystems = nixpkgs.lib.genAttrs (builtins.attrNames platforms);
    in {
        packages = forAllSystems (system:
            let
                pkgs = import nixpkgs { inherit system; };
                info = platforms.${system};
            in {
                default = pkgs.stdenv.mkDerivation {
                    pname = "loclx";
                    version = "latest";

                    src = pkgs.fetchzip {
                        url = info.url;
                        sha256 = info.sha256;
                    };

                    installPhase = ''
                        mkdir -p $out/bin
                        cp loclx $out/bin/
                        chmod +x $out/bin/loclx
                    '';
                };
            }
        );
    };
}
