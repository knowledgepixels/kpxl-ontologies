#!/bin/bash

set -e

USAGE="$ scripts/make-rel-index.sh"

if [ ! -z $1 ]; then
  echo "Usage: $USAGE"; exit 1
fi

LASTRELEASE=$(scripts/get-last-release-nr.sh rel)

LASTINDEX=$(
  cat releases/rel.index.$LASTRELEASE.trig \
  | egrep '^@prefix this:' \
  | tail -1 \
  | sed -r 's/.*<(.*)>.*/\1/'
)

if [ -z "$LASTINDEX" ]; then
  echo "No last index found"
  LASTINDEXARG=""
else
  echo "Supersedes index: $LASTINDEX"
  LASTINDEXARG="-x $LASTINDEX"
fi

echo "Making index..."
scripts/np mkindex \
  -u https://w3id.org/kpxl/rel/np/index/ \
  -c https://orcid.org/0000-0002-1267-0234 \
  -t "Scientific Relations Ontology" \
  -l https://creativecommons.org/publicdomain/zero/1.0/ \
  $LASTINDEXARG \
  -o rel.index.trig \
  rel.trig

