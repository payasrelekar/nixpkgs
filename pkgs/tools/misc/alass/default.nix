{ stdenv, lib, rustPlatform, ffmpeg, makeWrapper, fetchFromGitHub, Security }:

rustPlatform.buildRustPackage rec {
  pname = "alass";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "kaegi";
    repo = "alass";
    rev = "v${version}";
    sha256 = "q1IV9TtmznpR7RO75iN0p16nmTja5ADWqFj58EOPWvU=";
  };

  cargoSha256 = "6CVa/ypz37bm/3R0Gi65ovu4SIwWcgVde3Z2W1R16mk=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  propagatedBuildInputs = [ ffmpeg ];

  nativeBuidInputs = [ makeWrapper ];

  postInstallPhase = ''
    wrapProgram $out/bin/alass-cli $out/bin/alass-cli-wrapped --prefix PATH : "${
      lib.makeBinPath [ ffmpeg ]
    }"
  '';

  doInstallCheck = true;
  postInstallCheck = ''
    $out/bin/alass-cli --help > /dev/null
  '';

  meta = with lib; {
    description =
      "A command-line tool for automatic language-agnostic subtitle synchronization";
    homepage = "https://github.com/kaegi/alass";
    license = licenses.gpl3;
    maintainers = [ maintainers.payas ];
  };
}
