Film bearbeiten / attending motion pictures
===========================================

Mit diesem Skript kann man einen Film bearbeiten, wie zum Beispiel Werbung raus schneiden, das Bildformat ändern, schwarze Ränder entfernen, BluRay ähnlichen AVC-Code erzeugen und andere nützliche Dinge.

Die Dateien müssen alle zusammen in dem gleichen Verzeichnis (z.B. in ~/bin oder /home/bin) liegen.

Dieses Skript ist komplett in "Bash" (und den gängisten Kommandozeilenwerkzeugen) geschrieben worden.
Es wird von mir hauptsächlich auf FreeBSD eingesetzt aber gelegentlich auch auf Ubuntu-Linux.
Ich bin bestrebt den Kode so zu gestalten, dass er auf allen BSD's und allen Linux'en laufen sollte.
Wenn man die entsprechenden Programme installiert, sollte es ggf. auch auf einem Mac laufen.


beispielhafte Parameterkombinationen
====================================

Wenn das Format des Ausgabefilmes mit „-idar“ verändert wird, dann muss es Verzerrungen geben. Diese -i…-Optionen sollen die Eigenschaften des Eingabefilmes überschreiben, damit man defekte Filme, bei denen z.B. die Kreise nicht „rund“ sind wieder reparieren kann.
Wenn man aber die Option „-odar“ verwendet, darf nichts verzerrt werden! In diesem Fall sollen nur „schwarze Balken“ (entweder oben und unten oder links und rechts) an das Bild angefühgt werden. Diese -o…-Optionen sollen die Eigenschaften des Ausgabefilmes verändern.
Die Option „-std“ formt die Bildpunkte in ein quadratischen Format um, das ist der Blu-Ray-Standard. Verzerrungen darf es im Bild dadurch aber nicht geben.

Beispiele:
----------

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
