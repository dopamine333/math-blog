#!/bin/bash
# One-command development environment.
# Starts both of these, side by side:
#   watch.sh  rebuilds the forest whenever trees/, assets/ or theme/ change
#   serve.sh  serves output/ at http://localhost:1313 with live reload
# Press Ctrl+C once to stop everything.

# On Ctrl+C, termination or exit, stop every process in this script's
# process group, so fswatch and live-server don't keep running in the
# background. The first part of the trap clears the trap so the cleanup
# can't run twice.
trap 'trap - INT TERM EXIT; kill 0' INT TERM EXIT

./watch.sh &
./serve.sh &

# Keep this script alive while the two background jobs run.
wait