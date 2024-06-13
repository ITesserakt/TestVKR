{
  description = "TestVKR NixOS flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    erosanix.url = "github:emmanuelrosa/erosanix";
  };

  outputs = { self, nixpkgs, erosanix }: let
  	system = "x86_64-linux";
	pkgs = import nixpkgs { inherit system; };
  in {
    packages.x86_64-linux = with (pkgs // erosanix.packages.x86_64-linux // erosanix.lib.x86_64-linux); {
      test-vkr = mkWindowsApp rec {
      	wine = wineWow64Packages.stagingFull;
      	
      	pname = "test-vkr";
      	version = "1.0.0";

      	src = builtins.fetchurl {
      	  url = "http://vkr.bmstu.ru/TestVkr.exe";
      	  sha256 = "sha256:1vbffk3cmg4vsynp1crh9zqz8ynvb08v4fy6fqyknhwjvgccpxx5";
      	};

      	dontUnpack = true;

      	wineArch = "win64";
      	inputHashMethod = "store-path";

      	winAppRun = ''
      	  wine ${src} "$ARGS"
      	'';

      	installPhase = ''
      	  runHook preInstall

		  ln -s $out/bin/.launcher $out/bin/${pname}

      	  runHook postInstall
      	'';
      };
      
      default = self.packages.x86_64-linux.test-vkr;
    };
  };
}
