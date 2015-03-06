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

document.addEventListener("DOMContentLoaded", function() {
  var form = document.querySelector("form");

  if (!form) { return; }

  var input = document.querySelector("input[type=file]");

  input.addEventListener("upload:start", function() {
    var p = document.createElement("p");
    p.textContent = "Upload started.";
    form.appendChild(p);
  });

  input.addEventListener("upload:success", function() {
    var p = document.createElement("p");
    p.textContent = "Upload succeeded.";
    form.appendChild(p);
  });

  input.addEventListener("upload:progress", function(event) {
    var p = document.createElement("p");
    p.textContent = "Upload progess " + event.detail.progress.loaded + " of " + event.detail.progress.total + ".";
    form.appendChild(p);
  });
});
