{ stdenv, fetchFromGitHub, libconfig, libevent, openssl
, readline, zlib, lua5_2, python, pkgconfig, jansson
, runtimeShell
}:

stdenv.mkDerivation rec {
  name = "telegram-cli-2020-01-06";

  src = fetchFromGitHub {
    owner = "kenorb-contrib";
    repo = "tg";
    rev = "20200106";
    sha256 = "0l5dxq2cylwbbli7m5wqdk46qx4fhvf0igyw7fffq87wcsplz061";
    fetchSubmodules = true;
  };

  buildInputs = [
    libconfig libevent openssl readline zlib
    lua5_2 python pkgconfig jansson
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp ./bin/telegram-cli $out/bin/telegram-wo-key
    cp ./tg-server.pub $out/
    cat > $out/bin/telegram-cli <<EOF
    #!${runtimeShell}
    $out/bin/telegram-wo-key -k $out/tg-server.pub "\$@"
    EOF
    chmod +x $out/bin/telegram-cli
  '';

  meta = {
    description = "Command-line interface for Telegram messenger";
    homepage = https://telegram.org/;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ ];
  };
}
