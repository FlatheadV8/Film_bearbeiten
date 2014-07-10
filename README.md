Film_bearbeiten
===============

Mit diesem Skript kann man einen Film bearbeiten, wie zum Beispiel Werbung raus schneiden, das Bildformat ändern, schwarze Ränder entfernen, BluRay ähnlichen AVC-Code erzeugen und andere nützliche Dinge.

Die Dateien müssen alle zusammen in dem gleichen Verzeichnis (z.B. in ~/bin oder /home/bin) liegen.


beispielhafte Parameterkombinationen
====================================

Wenn das Format des Ausgabefilmes mit „-idar“ verändert wird, dann muss es Verzerrungen geben. Diese -i…-Optionen sollen die Eigenschaften des Eingabefilmes überschreiben, damit man defekte Filme, bei denen z.B. die Kreise nicht „rund“ sind wieder reparieren kann.
Wenn man aber die Option „-odar“ verwendet, darf nichts verzerrt werden! In diesem Fall sollen nur „schwarze Balken“ (entweder oben und unten oder links und rechts) an das Bild angefühgt werden. Diese -o…-Optionen sollen die Eigenschaften des Ausgabefilmes verändern.
Die Option „-std“ formt die Bildpunkte in ein quadratischen Format um, das ist der Blu-Ray-Standard. Verzerrungen darf es im Bild dadurch aber nicht geben.

Beispiele:
  /home/bin/film_bearbeiten.sh -rein Test.mkv -raus CCC0 -std -skal 640x480
  /home/bin/film_bearbeiten.sh -rein Test.mkv -raus CCC1 -std -skal 720x512
  /home/bin/film_bearbeiten.sh -rein Test.mkv -raus CCC2 -std -odar 4/3 -crop 202,200,0,2
  /home/bin/film_bearbeiten.sh -rein Test.mkv -raus CCC3 -std -odar 16/9 -crop 202,200,0,2
  /home/bin/film_bearbeiten.sh -rein Test.mkv -raus CCC4 -std -crop 202,200,0,2
  /home/bin/film_bearbeiten.sh -rein Test.mkv -raus CCC5 -std -skal 720x512 -crop 202,200,0,2
  /home/bin/film_bearbeiten.sh -rein Test.mkv -raus CCC6 -skal 640x480
  /home/bin/film_bearbeiten.sh -rein Test.mkv -raus CCC7 -skal 720x512
  /home/bin/film_bearbeiten.sh -rein Test.mkv -raus CCC8 -odar 4/3 -crop 202,200,0,2
  /home/bin/film_bearbeiten.sh -rein Test.mkv -raus CCC9 -odar 16/9 -crop 202,200,0,2
  /home/bin/film_bearbeiten.sh -rein Test.mkv -raus CCC10 -crop 202,200,0,2
  /home/bin/film_bearbeiten.sh -rein Test.mkv -raus CCC11 -skal 720x512 -crop 202,200,0,2
  /home/bin/film_bearbeiten.sh -rein Test.mkv -raus CCC12 -progress -quad -skal 214x120 -anr 1,7

Noch gibt es möglicherweise ein paar Rechenfehler, bei der Bildformatsberechnung. Deshalb kann es sein, dass in einigen Fällen die Kreise beim Ergebnis nicht immer rund geblieben sind, dann muss man etwas genauere Angaben bei der Eingabe machen (z.B.: „-idar“, „-ipar“, „-odar“, „-opar“). Das wird aber in späteren Versionen ausgebessert.

  ================================================================================

  /home/bin/film_bearbeiten.sh -hilfe

  --------------------------------------------------------------------------
  v2014062100 | 1 Funktionen


  --------------------------------------------------------------------------
  v2014062100 | 2 Parameter


                        HILFE:
                        /home/bin/film_bearbeiten.sh -hilfe

                ASPECT:
                -odar 16/9

                ID der gewünschten Tonspur (Audio-ID):
                -anr 1

                gewuenschte Anzahl der Ausgabe-Tonspuren
                -aspuren 2

                Audioqualität (Std.: 5; mögliche Werte: 0-10):
                -aqual 5

                Videoqualität (Std.: 7; mögliche Werte: 0-10):
                -vqual 5

                CROP_PARAMETER-Werte:
                -crop 720:432:0:72

                (nur für AVC/x264) Audio-Codec: wave aac mp2 mp3 ogg
                -acodec wave
                -acodec aac
                -acodec mp2
                -acodec mp3
                -acodec ogg

                (nur für AVC/x264) ein um 1300ms (1,3 Sekunden) verzögertes einsätzen der transcodierten Tonspur:
                -dtton 1300

                (nur für AVC/x264) ein um 300ms (0,3 Sekunden) verzögertes einsätzen der Video-Spur:
                -dvideo 300

                Crop-Test:
                -testcrop       (ist nur zum schnelleren manuellen ermitteln der Crop-Werte, optimierende Parameter werden ignoriert)
                                (macht nur zusammen mit '-crop' Sinn, z.B. so: -rein Film.mpg -raus test01 -crop 75,2,75,2 -testcrop)

                Deinterlacing:
                -progress 

                mit schwarzen Balken zu einem Standardformat von 4/3 oder 16/9 erweitern (nur für AVC/x264):
                -autoformat

                Bilder pro Sekunde im Zielvideo:
                -ofps 20

                HILFE:
                -hilfe

                CPU-Kerne:
                -kerne 1

                (nur für AVC/x264) automatische Längenanpassung durch Audio-stretch aktivieren:
                -syncstretch

                (nur für AVC/x264) automatische Laufzeitsyncronisation zw. Audio- und Video-Spur durch MKV-Container-Parameter deaktivieren:
                -syncmkv

                diese Abschnitte aus dem Film sollen erhalten bleiben, Angaben in Sekunden der Spielzeit des Originals
                -schnitt '105-1250 1578.5-2498.3'

                die Ausgabe soll quadratische Bildpunkte haben
                -quad

                das Seitenformat der Bildpunkte der Ausgabe (PAR/SAR) - VIDEOPixel:
                -opar 1         (die Ausgabe wird quadratische Bildpunkte haben)
                -opar ntsc      (720x480 wird so dargestellt wie 640x480)
                -opar pal       (720x576 wird so dargestellt wie 768x576)
                -opar dvb       (720x576 wird so dargestellt wie 1024x576)
                -opar 16/15     (als Bruch angeben)
                -opar 1.0666666 (als Fliesskommazahl angeben)

                Profil:
                -profil avc          (synonym für x264; das ist der Standard, wenn kein Profil angegeben wird)
                -profil x264         (Video-Codec: x264 / Audio-Codec: AAC)
                -profil xmp3         (Video-Codec: x264 / Audio-Codec: MP3)
                -profil xogg         (Video-Codec: x264 / Audio-Codec: OGG)
                -profil asp          (synonym für xvid)
                -profil divx         (Video-Codec: DivX 4/5 / Audio-Codec: MP3)
                -profil dx50         (Video-Codec: DivX 5 / Audio-Codec: MP3)
                -profil sp3dx        (Video-Codec: DivX 5 / Audio-Codec: MP2)
                -profil xvid         (Video-Codec: Xvid / Audio-Codec: MP3)
                -profil sp3xv        (Video-Codec: Xvid / Audio-Codec: MP2)
                -profil em880        (Video-Codec: Xvid / Audio-Codec: MP2; optimiert für den MiniPlayer 'entryx EM880RB')
                -profil 3gp          MPEG-4 / 3GPP Media Release 4 (3gp4) / BaseLine@1.0 (H.263, qcif) / Advanced Audio Codec (AAC, 24KHz, 64Kbps)
                -profil sp5dx        (Video-Codec: Xvid / Audio-Codec: MP3)
                -profil sp5xv        (Video-Codec: Xvid / Audio-Codec: MP3)
                -profil sqcif        (-skal 128x96)
                -profil qcif         (-skal 176x144) / 176x144 [PAR 16:11 DAR 16:9]
                -profil qvga         (-skal 320x240)
                -profil cif          (-skal 352x288)
                -profil vga          (-skal 640x480)
                -profil 4cif         (-skal 704x576)

                Name der Quell-Video-Datei:
                -rein Alf.mpg
                Rauschunterdrückungswert:
                -entrauschen 100
                Bild auf diesen Wert scalieren:
                -skal 640x512
                Nummer der gewünschten TonSpur:
                -ts 2
                Name des Zielvideos (ohne Endung):
                -raus Alf_avc

                Parametersammlungen:
                -std   -> '-autoformat'
                -stdtv -> '-autoformat -progress -opar pal'

                z.B.:
                Es muss mindestens dieser Parameter gesetzt werden:
                /home/bin/film_bearbeiten.sh -rein film03.mpg

                /home/bin/film_bearbeiten.sh -rein film02.mpg -crop 75,2,75,2 -raus test01 -testcrop
                /home/bin/film_bearbeiten.sh -rein film02.mpg -crop 75,2,75,2
                /home/bin/film_bearbeiten.sh -rein film01.mpg -crop 72,0,72,0 -skal 320x288 -idar 16/9 -ofps 20
                /home/bin/film_bearbeiten.sh -rein film01.mpg -crop 72:0:72,0 -skal 320x240 -progress -ipar pal

                MPEG 4 Part 10 (x264 / AAC); es muss kein Profil angegeben werden:
                /home/bin/film_bearbeiten.sh -rein film02.mpg

                MPEG 4 Part 10 (x264 / MP3):
                /home/bin/film_bearbeiten.sh -rein film02.mpg -profil xmp3

                MPEG 4 Part 10 (x264 / OGG):
                /home/bin/film_bearbeiten.sh -rein film02.mpg -profil xogg

                MPEG 4 Part 2 (Xvid):
                /home/bin/film_bearbeiten.sh -rein film02.mpg -profil asp
                /home/bin/film_bearbeiten.sh -rein film02.mpg -profil xvid

                MPEG 4 Part 2 (DivX 4/5 - kompatibel):
                /home/bin/film_bearbeiten.sh -rein film02.mpg -profil divx

                MPEG 4 Part 2 (DivX 5 - kompatibel):
                /home/bin/film_bearbeiten.sh -rein film02.mpg -profil dx50

                simple profile at level 3 (allgemein für MiniPlayer / DivX 5):
                /home/bin/film_bearbeiten.sh -rein film02.mpg -profil sp3dx

                simple profile at level 3 (allgemein für MiniPlayer / Xvid):
                /home/bin/film_bearbeiten.sh -rein film02.mpg -profil sp3xv

                fuer einen MiniPlayer 'entryx EM880RB' (Xvid):
                /home/bin/film_bearbeiten.sh -rein film02.mpg -profil em880
</code>
