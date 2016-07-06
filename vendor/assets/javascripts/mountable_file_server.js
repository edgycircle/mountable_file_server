(function() {
  var MountableFileServerUploader = function(options) {
    return {
      url: options.url,
      uploadFile: function(options) {

        var file = options.file;
        var type = options.type;
        var onStart = options.onStart || function() {};
        var onProgress = options.onProgress || function() {};
        var onSuccess = options.onSuccess || function() {};
        var xhr = new XMLHttpRequest();
        var formData = new FormData();

        formData.append('file', file);
        formData.append('type', type);

        xhr.open('POST', this.url, true);

        xhr.onreadystatechange = function() {
          if (xhr.readyState === 4 && xhr.status === 201) {
            var response = JSON.parse(xhr.responseText);

            response.original_filename = file.name;

            onSuccess(response);
          }
        }

        xhr.upload.addEventListener('progress', function(progressEvent) {
          if (progressEvent.lengthComputable) {
            onProgress(progressEvent);
          }
        });

        xhr.send(formData);

        onStart();
      }
    };
  };

  window.MountableFileServerUploader =  MountableFileServerUploader;
})();
