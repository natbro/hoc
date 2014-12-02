#!/bin/bash

convert Icon-original.png -resize 512x512 iTunesArtwork.png
mv iTunesArtwork.png iTunesArtwork
convert Icon-original.png -resize 1024x1024 iTunesArtwork@2x.png
mv iTunesArtwork@2x.png iTunesArtwork@2x
convert Icon-original.png -resize 57x57   Icon.png
convert Icon-original.png -resize 114x114 Icon@2x.png
convert Icon-original.png -resize 171x171 Icon@3x.png
convert Icon-original.png -resize 72x72   Icon-72.png
convert Icon-original.png -resize 144x144 Icon-72@2x.png
convert Icon-original.png -resize 29x29   Icon-small.png
convert Icon-original.png -resize 58x58   Icon-small@2x.png
convert Icon-original.png -resize 87x87   Icon-small@3x.png
convert Icon-original.png -resize 50x50   Icon-Small-50.png
convert Icon-original.png -resize 100x100 Icon-Small-50@2x.png
convert Icon-original.png -resize 150x150 Icon-Small-50@3x.png
convert Icon-original.png -resize 120x120 Icon-60@2x.png
convert Icon-original.png -resize 180x180 Icon-60@3x.png
convert Icon-original.png -resize 40x40   Icon-40.png
convert Icon-original.png -resize 80x80   Icon-40@2x.png
convert Icon-original.png -resize 120x120 Icon-40@3x.png
convert Icon-original.png -resize 76x76   Icon-76.png
convert Icon-original.png -resize 152x152 Icon-76@2x.png
