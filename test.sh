#!/bin/bash

source ~/.bashrc

start=$(date +%s)

# Your script commands here
sleep 2
echo "Doing some work..."
sleep 1

end=$(date +%s)
elapsed=$((end - start))
formatted=$(date -u -d "@$elapsed" +"%H:%M:%S")
echo "Elapsed Time: $formatted"

