module ZendeskAPI
  class Attachment < Data
    def initialize(client, attributes)
      attributes[:file] ||= attributes.delete(:id)

      super
    end

    def save
      upload = Upload.create!(@client, attributes)
      self.token = upload.token
    end

    def to_param
      token
    end
  end

  class Upload < Data
    include Create
    include Destroy

    def id; token; end

    self.resource_name = 'uploads'
    self.singular_resource_name = 'upload'
    self.collection_paths = ['uploads']
    self.resource_paths = ['uploads/%{id}'] # TODO %{token}?

    has_many :attachments, class: 'Attachment'

    private

    def attributes_for_save
      attributes.changes
    end
  end
end
