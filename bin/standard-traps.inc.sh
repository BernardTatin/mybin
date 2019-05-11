#!/bin/sh
# This file must be included by a sh script
# be careful: 'local' variables are not so local!


# ----------------------------------------------------------------------
trap_exit() {
  echo "trap_exit ${retcode}"
  exit ${retcode}
}
trap_error() {
  retcode=${FAILURE}
  echo "trap_error ${retcode}"
}
trap_force_quit() {
  retcode=${FAILURE}
  echo "trap_force_quit ${retcode}"
}
# ----------------------------------------------------------------------
# trap trap_force_quit *
trap trap_force_quit TERM TSTP INT QUIT
trap trap_error HUP ILL ABRT FPE SEGV PIPE
trap trap_exit EXIT
