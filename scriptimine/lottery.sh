#!/bin/bash

PLAYER_FILE="player_numbers.txt"
LOTTERY_FILE="lottery_numbers.txt"
RESULTS_FILE="results.txt"

tyhjenda_mangufailid() {
    > "$PLAYER_FILE"
    > "$LOTTERY_FILE"
}

kysi_nimi() {
    local nimi
    read -p "Sisesta oma nimi: " nimi
    if [ -z "$nimi" ]; then
        nimi="Unknown"
    fi
    echo "$nimi"
}

on_taisarv() {
    local vaartus="$1"
    if [ -z "$vaartus" ]; then
        return 1
    fi
    if [ "$vaartus" -eq "$vaartus" ] 2>/dev/null; then
        return 0
    fi
    return 1
}

on_juba_failis() {
    local number="$1"
    local fail="$2"
    local rida
    while read rida; do
        if [ "$rida" = "$number" ]; then
            return 0
        fi
    done < "$fail"
    return 1
}

kysi_mangija_numbrid() {
    local count=0
    local number
    echo "Vali 5 erinevat numbrit vahemikust 1-50."
    while [ "$count" -lt 5 ]; do
        read -p "Number $((count + 1)): " number
        if [ -z "$number" ]; then
            echo "Viga: midagi ei sisestatud. Proovi uuesti."
            continue
        fi
        if ! on_taisarv "$number"; then
            echo "Viga: $number ei ole täisarv. Proovi uuesti."
            continue
        fi
        if [ "$number" -lt 1 ] || [ "$number" -gt 50 ]; then
            echo "Viga: number peab olema vahemikus 1-50. Proovi uuesti."
            continue
        fi
        if on_juba_failis "$number" "$PLAYER_FILE"; then
            echo "Viga: number $number on juba valitud. Proovi uuesti."
            continue
        fi
        echo "$number" >> "$PLAYER_FILE"
        count=$((count + 1))
    done
}

loosi_numbrid() {
    local count=0
    local number
    while [ "$count" -lt 5 ]; do
        number=$((RANDOM % 50 + 1))
        if on_juba_failis "$number" "$LOTTERY_FILE"; then
            continue
        fi
        echo "$number" >> "$LOTTERY_FILE"
        count=$((count + 1))
    done
}

kontrolli_tabamused() {
    local number
    tabamused=0
    while read number; do
        echo "Kontrollin numbrit $number..."
        if on_juba_failis "$number" "$LOTTERY_FILE"; then
            echo "TABAMUS!"
            tabamused=$((tabamused + 1))
        else
            echo "Ei tabanud."
        fi
        echo
    done < "$PLAYER_FILE"
}

hinda_tulemus() {
    local tabamused="$1"
    if [ "$tabamused" -eq 5 ]; then
        echo "JACKPOT!"
    elif [ "$tabamused" -eq 4 ]; then
        echo "Väga hea tulemus!"
    elif [ "$tabamused" -eq 3 ]; then
        echo "Hea tulemus."
    elif [ "$tabamused" -eq 2 ]; then
        echo "Kaks tabamust."
    elif [ "$tabamused" -eq 1 ]; then
        echo "Üks tabamus."
    else
        echo "Seekord tabamusi ei olnud."
    fi
}

salvesta_tulemus() {
    local nimi="$1"
    local tabamused="$2"
    local hinnang="$3"
    echo "========================================" >> "$RESULTS_FILE"
    echo "Date: $(date)" >> "$RESULTS_FILE"
    echo "Player: $nimi" >> "$RESULTS_FILE"
    echo "Player numbers:" >> "$RESULTS_FILE"
    cat "$PLAYER_FILE" >> "$RESULTS_FILE"
    echo "Lottery numbers:" >> "$RESULTS_FILE"
    cat "$LOTTERY_FILE" >> "$RESULTS_FILE"
    echo "Matches: $tabamused" >> "$RESULTS_FILE"
    echo "Result: $hinnang" >> "$RESULTS_FILE"
    echo >> "$RESULTS_FILE"
}

tyhjenda_mangufailid
mangija=$(kysi_nimi)
kysi_mangija_numbrid
echo
echo "Mängija valitud numbrid:"
cat "$PLAYER_FILE"
echo
echo "Loosin võidunumbrid..."
loosi_numbrid
echo "Võidunumbrid:"
cat "$LOTTERY_FILE"
echo
kontrolli_tabamused
hinnang=$(hinda_tulemus "$tabamused")
echo "Mängija: $mangija"
echo "Tabamusi: $tabamused / 5"
echo "$hinnang"
salvesta_tulemus "$mangija" "$tabamused" "$hinnang"
echo
echo "Tulemus lisati faili $RESULTS_FILE"
