#!/usr/bin/env bash
set -x

term_handler() {
  echo "Stopping the server process with PID $PID"
  erl -noshell -name "term@127.0.0.1" -eval "rpc:call('app@127.0.0.1', init, stop, [])" -s init stop
  echo "Stopped"
}

trap 'term_handler' TERM INT

elixir --name app@127.0.0.1 -S mix run --no-halt &
PID=$!

echo "Started the server process with PID $PID"
wait $PID

# remove the trap if the first signal received or 'mix run' stopped for some reason
trap - TERM INT

# return the exit status of the 'mix phoenix server'
wait $PID
EXIT_STATUS=$?

exit $EXIT_STATUS
