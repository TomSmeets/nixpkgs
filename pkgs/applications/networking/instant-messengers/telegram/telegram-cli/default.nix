{ stdenv, fetchgit, libconfig, libevent, openssl
, readline, zlib, lua5_2, python, pkgconfig, jansson
, runtimeShell
}:

stdenv.mkDerivation rec {
  name = "telegram-cli-2020-01-06";

  src = fetchgit {
    url = "https://github.com/kenorb-contrib/tg.git";
    sha256 = "0l5dxq2cylwbbli7m5wqdk46qx4fhvf0igyw7fffq87wcsplz061";
    rev = "20200106";
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
    maintainers = [ stdenv.lib.maintainers.jagajaga ];
  };
}
