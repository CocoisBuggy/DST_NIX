{ pkgs }:
pkgs.writeShellApplication {
  name = "dst-server-foreground";

  runtimeInputs = with pkgs; [
    coreutils
    findutils
  ];

  text = ''
    set -euo pipefail

    NAME=""
    while [[ $# -gt 0 ]]; do
      case "$1" in
        --name)
          NAME="$2"
          shift 2
          ;;
        *)
          echo "Usage: $0 --name <instance-name>"
          exit 1
          ;;
      esac
    done

    if [[ -z "$NAME" ]]; then
      echo "Error: --name is required"
      exit 1
    fi

    BASE_DIR="/tmp/dstserver/$NAME"
    mkdir -p "$BASE_DIR"/{Master,Caves}

    echo "[GAMEPLAY]" > "$BASE_DIR/cluster.ini"
    echo "game_mode = survival" >> "$BASE_DIR/cluster.ini"
    echo "FAKE_CLUSTER_TOKEN" > "$BASE_DIR/cluster_token.txt"

    echo "[NETWORK]" > "$BASE_DIR/Master/server.ini"
    echo "server_port = 11000" >> "$BASE_DIR/Master/server.ini"

    echo "[NETWORK]" > "$BASE_DIR/Caves/server.ini"
    echo "server_port = 11001" >> "$BASE_DIR/Caves/server.ini"

    cp ${../entrypoint.sh} "$BASE_DIR/entrypoint.sh"
    chmod +x "$BASE_DIR/entrypoint.sh"

    echo "Launching DST server: $NAME in $BASE_DIR"
    cd "$BASE_DIR"
    exec ./entrypoint.sh
  '';
}
