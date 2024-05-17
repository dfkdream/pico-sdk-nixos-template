{
	description = "Raspberry pi pico development environment";
	inputs.flake-utils.url = "github:numtide/flake-utils";

	outputs = {self, nixpkgs, flake-utils}:
		flake-utils.lib.eachDefaultSystem (system:
		let
			pkgs = nixpkgs.legacyPackages.${system};
			pico-sdk-151 = with pkgs; (pico-sdk.overrideAttrs (o: 
			rec {
				pname = "pico-sdk";
				version = "1.5.1";
				src = fetchFromGitHub {
					fetchSubmodules = true;
					owner = "raspberrypi";
					repo = pname;
					rev = version;
					sha256 = "sha256:GY5jjJzaENL3ftuU5KpEZAmEZgyFRtLwGVg3W1e/4Ho=";
				};
			}));
		in {
			devShell = pkgs.mkShell {
				buildInputs = with pkgs; [
					cmake
					gcc-arm-embedded
					pico-sdk-151
					python3
				];
				shellHook = with pkgs; ''
					export PICO_SDK_PATH="${pico-sdk-151}/lib/pico-sdk"
				'';
			};
		});
}
