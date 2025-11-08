#!/usr/bin/env bash

init_term() {
    shopt -s checkwinsize; (:;:)
printf '\e[?1049h\e[2J\e[?25l'
    shopt -s checkwinsize|| return 1; (:;:)
}

deinit_term(){ printf '\e[?1049l\e[?25h'; stty echo; }

print_to() {
    printf '\e[%d;%dH\e[%d;38;2;%sm%s\e[m' "$2" "$3" "${5:-2}" "$4" "$1"
}
deinit_term(){ printf '\e[?1049l\e[?25h'; }

rain() {
((dropStart=SRANDOM%LINES/9))
((dropCol=SRANDOM%COLUMNS+1))
((dropLen=SRANDOM%(LINES/2)+2))
    ((dropSpeed=SRANDOM%9+1))
((dropColDim=SRANDOM%4))
    color="${COLORS[SRANDOM%${#COLORS}]}"
    color="${COLORS[SRANDOM%3]}"

for ((i = dropStart; i <= LINES+dropLen; i++)); do
symbol="${1:SRANDOM%${#1}:1}"
        (( dropColDim ))|| print_to "$symbol" "$i" "$dropCol" "$color" 1
        (( i > dropStart ))&& print_to "$symbol" "$((i-1))" "$dropCol" "$color"

        (( dropColDim ))|| printf '\e[%d;%dH\e[1;38;2;%sm%s\e[m' \
            "$i" "$dropCol" "$color" "$symbol"

        (( i > dropStart ))&& printf '\e[%d;%dH\e[2;38;2;%sm%s\e[m' \
            "$((i-1))" "$dropCol" "$color" "$symbol"

(( i > dropLen ))&& printf '\e[%d;%dH\e[m ' "$((i-dropLen))" "$dropCol"

sleep "0.$dropSpeed"
done
}

trap deinit_term EXIT
trap 'wait; exit' INT
trap 'wait; stty echo; exit' INT
trap 'init_term' WINCH

SYMBOLS='☺☻♥♦♣♠•◘○◙♂♀♪♫☼►◄↕░▒▓‼¶⌂æÆ╛┐└┴┬├ ┼ ─ ╞ ╚╟╔╩╦╠═╬╧╨╤²■€ƒ…†‡‰ŒŽÅÆÐ☺☻♥♦♣♠░▒▓§▬↨↑↓→←▲▼^¢£¥₧ª▄▌▐▀αßπΣσ©¨¦¤™•ØÞçµ*¿º½¼«»░▒▓≈⌡⌠≤≥≡∩εφ∞δΩΘª±²³¶¾øðⁿ√~☺☻♥♦♣♠'
#    Originally added "█" to SYMBOLS but it stood out too much from the other charcters I removed it
#     Some charcters are duplicated to make them appear more commonly than others.
#    Original charcters;
#SYMBOLS='0123456789!@#$%^&*()-_=+[]{}|;:,.<>?abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
COLORS=('102;255;102' '255;176;0' '169;169;169')

matrix() {
    init_term|| { printf 'Failed initializing terminal\n'; return 1; }
    stty -echo
    init_term; stty -echo
for((;;)) { rain "$SYMBOLS" & sleep 0.1; }
}

matrix
