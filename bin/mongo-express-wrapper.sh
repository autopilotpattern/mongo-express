#!/bin/bash
set -e

# we can't inject new environment variables directly into Container Pilot, so instead we update/source a file at startup which our co-processes can modify for us
if [ -f /etc/mongo-express-env ]; then
	. /etc/mongo-express-env
fi

exec "$@"
