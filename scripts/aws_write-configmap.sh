#!/usr/bin/env bash

ansi --green "running 'kubectl apply -f' on outputed config_map_aws_auth"

terraform output config_map_aws_auth | kubectl apply -f -

ansi --green "Done!"

exit 0