The fundamental idea is that your application only deals with identifiers of uploaded files in string form. No need to handle files directly. It should not complicate testing. It should allow files that are publicly accessible and private files that are not. Uploads happen via Ajax without additional work on the application developers side. It allows easy customization and adaption of the file upload process on the frontend to give a good user experience.

## Concept


## Moving Parts
`MountableFileServer::Endpoint` is a Sinatra application that can be mounted anywhere you want. It accepts uploads and responds with requested files if necessary. `MountableFileServer::Storage` is responsible for working with the actual files. Both take a `MountableFileServer::Configuration` which is used to define key settings specific to your usage scenario.

## Configuration
~~~ruby
configuration = MountableFileServer::Configuration.new stored_at: '~/uploads', mounted_at: '/uploads'
~~~

~~~ruby
storage = MountableFileServer::Storage.new config
upload = MountableFileServer::Upload.new file: file_parameters[:tempfile].read, type: 'public'

identifier = storage.store_temporary upload: upload
storage.move_to_permanent_storage identifier: identifier

storage.file_for identifier: identifier
storage.url_for identifier: identifier <- Maybe wo anders?
~~~

~~~html
<div class="js-mountable-file-server-input">
  <input type="file" name="avatar" data-endpoint="/uploads" data-type="public">
  <input type="hidden" name="avatar">
</div>
~~~

ist es doof das alle files gemischt in einem ordner liegen?


Statt normal_testing_test.rb test_normal_testing.rb
Wie kann man den test '...' do Syntax verwenden?
Verschiedene Formatbasierte Fake Uploads
root & stored_at vereinen und als Pathname speichern
Sinatra Methoden umbenennen
Dateien entfernen
Private Uploads
ActiveRecord Callbacks
Metadaten bei Upload mitsenden
Pfadkonstruktionen auf einen Bereich beschränken
Bilder modifizieren
README schreiben
input_class in input_wrapper_class oder so umbenennen
UploadIdentifier und Filename verwenden
  Nach außen gibt es kein private- / public-








Vokabular file identifier

visibility + filename = file identifier

file identifier -> filename



Bild Modifizierungs URL Konzept

imgix verwendet Query Parameter
Beispiel: http://assets.imgix.net/examples/octopus.jpg?auto=format&fit=crop&h=480&q=80&w=940

Das ist insofern problematisch das es auf der Festplatte keine echte Datei dafür gibt, sprich mit nginx kann man solch eine Datei nicht ausliefern selbst wenn sie schon einmal generiert wurde.

Deswegen würde ich gerne die Parameter im Dateinamen haben.

https://github.com/joenoon/url_safe_base64/blob/master/lib/url_safe_base64.rb
http://www.imagemagick.org/script/command-line-processing.php#geometry
https://github.com/minimagick/minimagick


if Gibt es die Datei?
  ausliefern
else
  basename = dateiname im request

  if gibt es basename
    bild mit parameter generieren
    bild speichern
    ausliefern
  else
    fehler
  end
end
