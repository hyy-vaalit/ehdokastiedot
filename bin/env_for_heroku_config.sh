#!/usr/bin/env bash

FILENAME=$1

if [ "${FILENAME}" == "" ]; then
  echo "Usage: $0 FILENAME"
  exit 1
fi

if [ ! -f "${FILENAME}" ]; then
  echo "File does not exist: ${FILENAME}"
  exit 1
fi

echo "Read following values from ${FILENAME}"
echo ""

attrs=""

while IFS='' read -r line || [[ -n "${line}" ]]; do
  # Skip lines which are empty or comments (start with #)
  if [ -z "${line}" ] || [ "${line:0:1}" == "#" ]; then
    continue
  fi
  echo "${line}"
  attrs="${attrs} ${line}"
done < "${FILENAME}"

echo ""
echo "Set environment variables in Heroku:"
echo ""
echo "heroku config:set ${attrs}"
