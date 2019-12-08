#!/bin/sh
find . \( -name "*.vala" \) -exec uncrustify -c uncrustify.vala.cfg --no-backup {} +
