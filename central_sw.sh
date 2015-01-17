#!/bin/bash
read desktop_id _ast \
    DG_ geometry \
    VP_ viewport \
    WA_ wa_off wa_size \
    title \
    < <(LANG=C wmctrl -d | grep '*')

geom_w=${geometry%x*}
geom_h=${geometry#*x}

# The workarea size isn't accurate, because the top/bottom panel is excluded. 
viewport_w=${wa_size%x*}
viewport_h=${wa_size#*x}

rows=$((geom_w / viewport_w))
cols=$((geom_h / viewport_h))

# Fix the viewport size
viewport_w=$((geom_w / rows))
viewport_h=$((geom_h / cols))

center_row=$((rows / 2))
center_col=$((cols / 2))

center_x=$((center_col * viewport_w))
center_y=$((center_row * viewport_h))

center_viewport=$center_x,$center_y

wmctrl -o $center_viewport
