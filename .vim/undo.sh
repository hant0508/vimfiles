#!/bin/bash

find ~/.vim/undo/ -size +500k -and -mtime +90 -o -mtime +180 -o -name "*%tmp%*" -delete
