#!/usr/bin/env bash

#set -x
VERSION="v2014110800"

#------------------------------------------------------------------------------#
### Arbeitsweise
# 1. dem Originalfilm (evtl. mit Croping) ins FFv1/WAV/MKV-Format uebersetzen
# 2. Film in diesem verlustfreien Format mit mkvtoolnix zuschneiden
# 3. zugeschnittene Filmteile wieder zu einem Filmstueck zusammensetzen
# 4. den neuen Film ins gewuenschte Format uebersetzen
#------------------------------------------------------------------------------#
# Dieses Skript kann Video-Dateien in verschiedenen Video-Codec's erstellen,
# z.B. "DivX 4/5", "Xvid" und "AVC" (mit x264).
# Auch verschiedene Audio-Codec's sind moeglich,
# z.B. "MP2" (nur 'Simple Profile 3'), "MP3", "OGG" oder "AAC".
#
# Im Standard werden "AVC"-Filme erstellt, die "Divx Plus"-kompatibel sind
# und zum Teil auch dem "AVCHD"- und "Blue-Ray"-Standard entsprechen.
# Es wird lediglich mit den Einschraenkungen in Bezug auf die erlaubten
# Auflaesungen, Audio-Codec's und den Video-Containern gebrochen.
# Damit sollten diese Dateien potentiell mit jedem Player abgespielt werden
# koennen, der "Blue-Ray"-, "AVCHD"- und "MKV"-Dateien abspielen kann.
#
# http://www.os4.org/wiki/film_transcodieren_in_mpeg4.html
#
# Sollten Sie einen Player fuer den PC suchen, der diese Filme abspielen kann,
# dann probieren sie doch mal den VLC aus:
# http://www.vlc.de/
# http://www.videolan.org/vlc/
#------------------------------------------------------------------------------#

### AVC-Profil
PROFILE="high"                          # Standardwert: es wird zur Zeit nur das Profil "high" unterstützt

### Standardwerte für nicht übergebene Parameter
TESTSZ="300-330"
SOLLTONSPUREN="2"
AS="NEIN"                               # im Standard kein Audio-stretch, zu aktivieren mit "-syncstretch"
DELAYOTON="0"                           # im Standard kein versetztes einsetzen der Originaltonspur, zu aktivieren mit z.B.: "-doton 1000"
DELAYTRANSTON="0"                       # im Standard kein versetztes einsetzen der transkodierten Tonspur, zu aktivieren mit z.B.: "-dtton 1000"
MKVSYNC="JA"                            # im Standard Synchronisation durch den MKV-Container, zu deaktivieren mit: "-syncmkv"
PPROFIL="avc"                           # im Standard wird ein AVC-Film erzeugt, zu ändern mit z.B.: "-profil asp"
RAUSCHW="0"                             # im Standard wird keine Rauschunterdrückung aktiviert, zu aktivieren mit z.B.: "-entrauschen 100"
ANPASSUNG="JA"                          # wichtig fuer die Simple-Profile

AUFRUF="${0} ${@}"

#------------------------------------------------------------------------------#

if [ "${#}" -eq "0" ] ; then
        echo "
        HILFE:
        ${0} -hilfe
        "
        exit 0
fi

ABARBEITUNGSNUMMER="0"
#==============================================================================#
MEINVERZEICHNIS="$(dirname ${0})"
. ${MEINVERZEICHNIS}/film_bearbeiten_funktionen                            || exit 1
. ${MEINVERZEICHNIS}/film_bearbeiten_parameter                             || exit 1
. ${MEINVERZEICHNIS}/film_bearbeiten_profile                               || exit 1
. ${MEINVERZEICHNIS}/film_bearbeiten_programme                             || exit 1
. ${MEINVERZEICHNIS}/film_bearbeiten_eigenschaften_lesen                   || exit 1    # ist noch nicht fertig

. ${MEINVERZEICHNIS}/film_bearbeiten_crop                                  || exit 1    # crop
. ${MEINVERZEICHNIS}/film_bearbeiten_direkt_transkodieren                  || exit 1    # mit FFmpeg direkt transkodieren, kein schneiden
. ${MEINVERZEICHNIS}/film_bearbeiten_quadratische_bildpunkte               || exit 1    # QuadratischePixel => Blu-Ray-Format
. ${MEINVERZEICHNIS}/film_bearbeiten_standardformat                        || exit 1    # Standard-Format => 4/3 oder 16/9

. ${MEINVERZEICHNIS}/film_bearbeiten_breit_und_hoch                        || exit 1    # wenn noetig, die Breite bzw. Hoehe ermitteln
. ${MEINVERZEICHNIS}/film_bearbeiten_bluray-kompatible_parameter_ermitteln || exit 1    # Blu-Ray-Kode

. ${MEINVERZEICHNIS}/film_bearbeiten_bearbeiten                            || exit 1    # in das Zwischenformat transkodiert | zerschneiden | wieder zum Film zusammensetzen
. ${MEINVERZEICHNIS}/film_bearbeiten_seitenverhaeltnis                     || exit 1    # das richtige Seitenverhaeltnis ermitteln
. ${MEINVERZEICHNIS}/film_bearbeiten_transkodieren                         || exit 1    # in Audio- und Video-Spur zerlegt | transkodieren | wieder zum Film zusammenmuxen
#==============================================================================#
