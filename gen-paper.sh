#!/bin/bash

thumb=300x200

for photo in alien bunker eye plane rig sub toxic ufo; do
    echo "$photo ..."
    convert "paper-raw/$photo.jpg" -auto-orient -thumbnail "${thumb}^" \
        -gravity center -extent "$thumb" "paper-raw/$photo-thumb.png"
done
