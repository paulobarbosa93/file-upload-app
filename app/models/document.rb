class Document < ApplicationRecord
  attr_accessor :file_contents

  belongs_to :item
  before_validation :parse_file
  has_attached_file :file
  validates_attachment :file, presence: true, content_type: { content_type: 'application/pdf' }

  def parse_file
    file = Paperclip.io_adapters.for(file_contents)
    file.original_filename = "pdfile.pdf"
    self.file = file
  end
end
