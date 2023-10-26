#!/bin/bash

set -euo pipefail

[ -z "${CI+1}" ] || exit 0

RESULT=$(bundle exec license_finder)
ERROR=$(cat <<-END
Some licenses are not approved! You need to run "bundle exec license_finder" to determine the missing licenses.
It appears the issues were the following:

"$RESULT"

Please check the licenses and especially commercial use terms, loop back to AppSec/Legal if needed.
Different way to approve a license, you can either accept a license kind:

bundle exec license_finder permitted_licenses add "Zlib"

Or specific packages:

bundle exec license_finder approvals add pako

Finally, please add the proper documentation and explanation in doc/dependency_decisions.yml
END
)

if echo "$RESULT" | grep "All dependencies are approved for use"
then
    exit 0
else
    echo "$ERROR"
    exit 1
fi
