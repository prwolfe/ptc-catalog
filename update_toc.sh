#!/bin/bash

################
# Relative location of Catalog Table of Contents
#
# This file will be overwritten by this script.
################

toc_loc=`pwd`
toc_loc+="/catalog/README.md"

################
# Front Matter
#
# This text is regenerated each time.
################

front_matter="# PTC Catalog Table of Contents\n\n
The table below lists the currently available Progress Tracking Cards (PTCs) with a brief description of their goals.\n\n
<!-- DO NOT EDIT THIS FILE DIRECTLY. It is generated by update_toc.sh! -->\n\n
[![Gitter](https://badges.gitter.im/bssw-psip/community.svg)](https://gitter.im/bssw-psip/community)\n\n
"

echo -e $front_matter > $toc_loc

################
# Table Setup
################

table_header_row="\n
| Title | Goal(s) |\n
|:-----:|:--------|"

echo -e $table_header_row >> $toc_loc

################
# Write table rows
################

cd catalog
for card in `ls`; do
    if [ "$card" != "README.md" ]; then
        echo "Processing $card"
        echo -n "| " >> $toc_loc

        # format title (first line) into a markdown link
        awk '{printf "[%s]", substr($0,3); exit}' $card >> $toc_loc
        echo -n "($card)" >> $toc_loc

        echo -n " | " >> $toc_loc
        # print first non-zeno length line under "## Target" heading
        awk '/## Target/ {in_target=1; next}
             (length($0) > 1) && (in_target) { printf "%s", $0; exit}' $card >> $toc_loc

        echo " | " >> $toc_loc
    fi
done
cd ..

echo "TOC updated. Please commit any changes."
