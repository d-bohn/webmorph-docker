#! /bin/bash

if [[ "$1" == "debug" ]]
then
    docker run --rm -it \
        -p 8080:8080 \
        -p 80:80 \
        -p 9001:9001 \
        -v /Users/dalbohn/Desktop/webmorph/image_folder/:/opt/assets/webmorph_images \
        local/webmorph /bin/bash
else
    docker run --rm \
        -p 8080:8080 \
        -p 80:80 \
        -p 9001:9001 \
        -v /Users/dalbohn/Desktop/webmorph/image_folder/:/opt/assets/webmorph_images \
        local/webmorph
fi

