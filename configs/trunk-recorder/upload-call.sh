#!/bin/bash

basename="${2%.*}"

# Uploads the unedited recording to test rdio-player instance on same machine.
# This allows for quick before/after normalization testing in case there is any suspicion that normalize-audio
# is causing issues

curl http://127.0.0.1:3000/api/trunk-recorder-call-upload \
     -F "key=secret-key-goes-here" \
     -F "audio=@${basename}.wav;type=audio/wav" \
     -F "meta=@${basename}.json;type=application/json" \
     -F "system=${1:-0}"


# normalizes the audio file
# If you upload to Broadcastify or OpenMHZ calls are normalized and converted automatically
# by trunk-recorder and/or the scripts provided by the service, but not if you host everything locally. 

normalize-audio -a -14dBFS "${2}"

# Uploads the normalized file to production rdio-player instance

curl http://x.x.x.x:3000/api/trunk-recorder-call-upload \
     -F "key=secret-key-goes-here" \
     -F "audio=@${basename}.wav;type=audio/wav" \
     -F "meta=@${basename}.json;type=application/json" \
     -F "system=${1:-0}"
