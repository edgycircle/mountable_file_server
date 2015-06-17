(function() {
  var lastUploadId = 0;
  var finishedUploads = [];

  var dispatchEvent = function($element, name, payload) {
    var event = document.createEvent('CustomEvent');

    event.initCustomEvent(name, true, false, payload);
    $element.dispatchEvent(event);
  };

  var uploadFile = function($element, file, uploadId) {
    var url = $element.getAttribute('data-endpoint');
    var type = $element.getAttribute('data-type');
    var xhr = new XMLHttpRequest();
    var formData = new FormData();

    formData.append('file', file);
    formData.append('type', type);

    xhr.open('POST', url, true);

    xhr.onreadystatechange = function() {
      if (xhr.readyState === 4 && xhr.status === 200) {
        finishedUploads.push(uploadId);

        dispatchEvent($element, 'upload:success', {
          uploadId: uploadId,
          identifier: xhr.responseText,
          wasLastUpload: lastUploadId == finishedUploads.length
        });
      }
    }

    xhr.upload.addEventListener('progress', function(progressEvent) {
      if (progressEvent.lengthComputable) {
        dispatchEvent($element, 'upload:progress', {
          uploadId: uploadId,
          progress: progressEvent
        });
      }
    });

    xhr.send(formData);

    dispatchEvent($element, 'upload:start', {
      uploadId: uploadId,
      file: file
    });
  };

  var internalUploadFiles = function($element, files) {
    for (var i = 0; i < files.length; i++) {
      uploadFile($element, files[i], ++lastUploadId);
    }
  };

  window.uploadFiles = internalUploadFiles;
})();
