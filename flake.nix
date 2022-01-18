{
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs";
    };

    outputs = {self, nixpkgs}:
        let pkgs = nixpkgs.legacyPackages.x86_64-linux;
        in {
            defaultPackage.x86_64-linux = pkgs.hello;

            devShell.x86_64-linux =
                pkgs.mkShell {
                    buildInputs = [
                        pkgs.httpie
                        pkgs.jq
                        pkgs.curl
                        # Stuff that has to be externally configured
                        pkgs.gnupg
                        pkgs.darcs
                        ## Stuff that isn't yet implemented
                        # domaPakages.passveil
                    ];
                };
        };
}
