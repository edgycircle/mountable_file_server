// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require mountable_file_server
//= require_tree .

document.addEventListener('DOMContentLoaded', function() {
  var form = document.querySelector("form");
  var input = document.querySelector("input[type=file]");

  if (!form || !input) { return; }

  var uploader = new MountableFileServerUploader({
    url: '/uploads'
  });

  input.addEventListener('change', function(event) {
    var self = this;

    for (var i = 0; i < this.files.length; i++) {
      uploader.uploadFile({
        file: this.files[i],
        type: 'public',
        onStart: function() {
          console.log('onStart');

          var p = document.createElement("p");
          p.textContent = "Upload started.";
          form.appendChild(p);
        },
        onProgress: function(progress) {
          console.log('onProgress', progress);

          var p = document.createElement("p");
          p.textContent = "Upload progess " + progress.loaded + " of " + progress.total + ".";
          form.appendChild(p);
        },
        onSuccess: function(response) {
          console.log('onSuccess', response);

          var $hiddenInput = document.createElement('input');

          $hiddenInput.value = response.fid;
          $hiddenInput.name = self.name;
          $hiddenInput.type = 'hidden';
          self.parentNode.insertBefore($hiddenInput, self.nextSibling);

          var p = document.createElement("p");
          p.textContent = "Upload succeeded.";
          form.appendChild(p);
        }
      });
    }
  });
});
