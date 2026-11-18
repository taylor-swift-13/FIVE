# Source this file from bash: source scripts/env.sh
FIVE_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
export FIVE_ROOT
eval "$(opam env --switch=five --set-switch)"
export PATH="$FIVE_ROOT/.tools/bin:$FIVE_ROOT/.tools/cbmc/usr/bin:$PATH"
