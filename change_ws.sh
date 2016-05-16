#!/bin/bash

CMD="$1"

NUM_WORKSPACES=3
NUM_COLS=3

NUM_ROWS=`echo "$NUM_WORKSPACES / $NUM_COLS" | bc`

CURRENT_WS=`wmctrl -d | grep \* | cut -d " " -f 1`

MOVE_LEFT="- $NUM_ROWS"
MOVE_RIGHT="+ $NUM_ROWS"
MOVE_UP="-1"
MOVE_DOWN="+1"

case $CMD in

    "Left" )
        NEW_WS=`echo $CURRENT_WS "-" $NUM_ROWS | bc`
        if [[ $NEW_WS -lt 0 ]]; then NEW_WS=$CURRENT_WS; fi
        ;;

    "Right" )
        NEW_WS=`echo $CURRENT_WS "+" $NUM_ROWS | bc`
        if [[ $NEW_WS -ge $NUM_WORKSPACES ]]; then NEW_WS=$CURRENT_WS; fi
        ;;

    "Up" )
        WS_COL=`echo $CURRENT_WS "%" $NUM_ROWS | bc`
        if [[ $WS_COL -eq 0 ]]; then
            {
                NEW_WS=$CURRENT_WS
            }
        else
            {
                NEW_WS=`echo $CURRENT_WS "- 1" | bc`
            }; fi
        ;;

    "Down" )
        NEW_WS=`echo $CURRENT_WS "+ 1" | bc`
        NEW_WS_COL=`echo $NEW_WS "%" $NUM_ROWS | bc`
        if [[ $NEW_WS_COL -eq 0 ]]; then NEW_WS=$CURRENT_WS; fi
        ;;
    
    "Center" )
        NEW_WS="4"
        ;;
    
    * )
        NEW_WS=$CMD

esac

wmctrl -s $NEW_WS
