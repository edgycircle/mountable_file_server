module MountableFileServer
  module AjaxUploadHelper
    module FormBuilder
      def ajax_upload_field(method, options = {})
        @template.ajax_upload_field(@object_name, method, objectify_options(options))
      end
    end

    def ajax_upload_field(object_name, method, options = {})
      file_input = file_field(object_name, method, options.merge({ data: { 'upload-url' => MountableFileServer.public_upload_url } }))
      hidden_input = hidden_field(object_name, method, options)
      content_tag(:div, class: MountableFileServer.configuration.input_class) do
        concat file_input
        concat hidden_input
      end
    end
  end
end
