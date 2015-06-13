document.addEventListener('change', onChange);

function onChange(event) {
  var $input = event.target;

  if (isFileUploadInput($input)) {
    uploadFileFromInput($input);
  }
}

function isFileUploadInput($element) {
  return $element.tagName === 'INPUT' &&
          $element.type === 'file' &&
          $element.getAttribute('data-endpoint') &&
          $element.getAttribute('data-type');
}

function uploadFileFromInput($input) {
  var url = $input.getAttribute('data-endpoint');
  var type = $input.getAttribute('data-type');
  var file = $input.files[0];
  var xhr = new XMLHttpRequest();
  var formData = new FormData();
  var $csrfElement = queryClosest($input, 'input[name=authenticity_token]');

  formData.append('file', file);
  formData.append('type', type);

  if ($csrfElement) {
    formData.append('_csrf_token', $csrfElement.value);
  }

  xhr.open('POST', url, true);

  xhr.onreadystatechange = function() {
    if (xhr.readyState === 4 && xhr.status === 200) {
      setInputValues(xhr.responseText, $input);
      dispatchEvent($input, 'upload:success', { url: xhr.responseText });
    }
  }

  xhr.upload.addEventListener('progress', function(progressEvent) {
    if (progressEvent.lengthComputable) {
      dispatchEvent($input, 'upload:progress', { progress: progressEvent });
    }
  });

  xhr.send(formData);
  dispatchEvent($input, 'upload:start', { file: file });
}

function setInputValues(response, $fileInput) {
  var $parent = queryClosest($fileInput, '.js-mountable-file-server-input');
  var $hiddenInput = $parent.querySelector('input[type=hidden]');

  $hiddenInput.value = response;
}

function queryClosest($element, selector) {
  if ($element !== null) {
    return $element.querySelector(selector) ||
            queryClosest($element.parentNode, selector);
  }
}

function dispatchEvent($element, name, payload) {
  var event = document.createEvent('CustomEvent');

  event.initCustomEvent(name, true, false, payload);
  $element.dispatchEvent(event);
};
