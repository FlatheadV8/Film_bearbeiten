#!/usr/bin/env bash

#set -x
VERSION="v2016032900"

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

### Standardwerte fuer nicht uebergebene Parameter
P_AAC_CODEC="libfaac"                   # leider ist das freie "aac" noch nicht fertig, deshalb verwenden wir erstmal "libfaac"
TESTSZ="300-330"
SOLLTONSPUREN="2"
AS="NEIN"                               # im Standard kein Audio-stretch, zu aktivieren mit "-syncstretch"
DELAYOTON="0"                           # im Standard kein versetztes einsetzen der Originaltonspur, zu aktivieren mit z.B.: "-doton 1000"
DELAYTRANSTON="0"                       # im Standard kein versetztes einsetzen der transkodierten Tonspur, zu aktivieren mit z.B.: "-dtton 1000"
PPROFIL="avc"                           # im Standard wird ein AVC-Film erzeugt, zu ändern mit z.B.: "-profil asp"
RAUSCHW="0"                             # im Standard wird keine Rauschunterdrückung aktiviert, zu aktivieren mit z.B.: "-entrauschen 100"
ANPASSUNG="JA"                          # wichtig fuer die Simple-Profile

VOLLBILDKONVERTIERER="yadif"            # Zeilenentflechtung / Deinterlacing

#------------------------------------------------------------------------------#
### ZwischenFormat (alt): FFv1 + PCM16 + MKV

# Dieses Format wurde fuer das zwischenspeichern verwendet, weil hier auf
# folgende Schwerpunkte wert gelegt wurde:
# 1. verlusstfreies Video-Format
# 2. moeglichst verlusstfreies Audio-Format
# 3. moeglichst universelles Container-Format

ZWISCHENFORMAT_VIDEO_CODEC="ffv1"               # verlusstfreier Codec
VIDEOFILTER_FORMAT="format='yuv444p|yuv444p16le|yuv422p|yuv422p16le|yuv420p'"
#ZWISCHENFORMAT_AUDIO_CODEC="pcm_s16le"         # CD-Qualitaet
ZWISCHENFORMAT_AUDIO_CODEC="pcm_f64le"          # beste PCM-Qualitaet
ZWISCHENFORMAT_AUDIO_FORMAT="wav"               # Audio-Container-Format
ZWISCHENFORMAT_AUDIO_ENDUNG="wav"               # Dateiendung
ZWISCHENFORMAT_FORMAT="matroska"                # Container-Format: matroska, mp4
ZWISCHENFORMAT_ENDUNG="mkv"                     # Dateiendung: mkv, mp4

#------------------------------------------------------------------------------#
### ZwischenFormat: x264 + PCM64 + MPEG-TS

# Dieses Format musste eingefuehrt werden, weil in Zukunft auch native
# MP4-Dateien erzeugt werden sollen.
# Leider kann das Programm MP4Box MKV nicht lesen, deshalb wurde ein
# Container-Format gesucht, welches moeglichst flexibel und kompatibel ist.
# MPEG-TS wird von den MKV- und den MP4-Tools gelesen, es kann aber leider nicht
# mit dem verlusstfreien Video-Codec FFv1 umgehen.
# x264 mit der Option "-crf 0" ist fast verlusstfrei.
# Leider ist "x264 -crf 0" aber wesentlich langsamer als FFv1.

#ZWISCHENFORMAT_VIDEO-CODEC="libx264 -crf 0"     # AVC in fast verlusstfreier
#ZWISCHENFORMAT_AUDIO-CODEC="pcm_f64le"          # beste PCM-Qualitaet
#ZWISCHENFORMAT_ENDUNG="m2t"                     # mpeg2ts, m2ts, m2t, mts, ts

#
# Dieses Vorgehen hat die ganze Sache so sehr verkompliziert, dass es
# verworfen wurde.
#
# Ursache fÃuer das Scheitern ist das Programm mp4box.
# Da auf das Programm mp4box, zum erzeugen der MP4-Dateien, verzichtet werden
# musste, wurde eine universelle Variante auf Basis von FFmpeg umgesetzt.
#

#------------------------------------------------------------------------------#

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

ABARBEITUNGSNUMMER="1"								# Offset zum zaehlen

# ${MEINVERZEICHNIS}/film_bearbeiten_01_hilfe.sht
. ${MEINVERZEICHNIS}/film_bearbeiten_02_funktionen.sht                            || exit 1
. ${MEINVERZEICHNIS}/film_bearbeiten_03_parameter.sht                             || exit 1
. ${MEINVERZEICHNIS}/film_bearbeiten_04_profile.sht                               || exit 1
. ${MEINVERZEICHNIS}/film_bearbeiten_05_programme.sht                             || exit 1
. ${MEINVERZEICHNIS}/film_bearbeiten_06_eigenschaften_lesen.sht                   || exit 1    # ist noch nicht fertig

. ${MEINVERZEICHNIS}/film_bearbeiten_07_crop.sht                                  || exit 1    # crop
. ${MEINVERZEICHNIS}/film_bearbeiten_08_standardformat.sht                        || exit 1    # Standard-Format => 4/3 oder 16/9
. ${MEINVERZEICHNIS}/film_bearbeiten_09_quadratische_bildpunkte.sht               || exit 1    # QuadratischePixel => Standard-Blu-Ray-Format
. ${MEINVERZEICHNIS}/film_bearbeiten_10_direkt_transkodieren.sht                  || exit 1    # mit FFmpeg direkt transkodieren, kein schneiden

. ${MEINVERZEICHNIS}/film_bearbeiten_11_breit_und_hoch.sht                        || exit 1    # wenn noetig, die Breite bzw. Hoehe ermitteln
. ${MEINVERZEICHNIS}/film_bearbeiten_12_bluray-kompatible_parameter_ermitteln.sht || exit 1    # Blu-Ray-Kode

. ${MEINVERZEICHNIS}/film_bearbeiten_13_bearbeiten.sht                            || exit 1    # in das Zwischenformat transkodiert | zerschneiden | wieder zum Film zusammensetzen
. ${MEINVERZEICHNIS}/film_bearbeiten_14_seitenverhaeltnis.sht                     || exit 1    # das richtige Seitenverhaeltnis ermitteln
. ${MEINVERZEICHNIS}/film_bearbeiten_15_transkodieren.sht                         || exit 1    # in Audio- und Video-Spur zerlegt | transkodieren | wieder zum Film zusammenmuxen
#==============================================================================#
