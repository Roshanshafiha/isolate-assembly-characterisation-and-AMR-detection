#!/bin/bash
input=$1
output=$2

grep "ID" $input > $output
