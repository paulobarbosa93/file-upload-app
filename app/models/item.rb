class Item < ApplicationRecord
  attr_accessor :document_data
  attr_accessor :image_base

  before_validation :parse_image
  has_attached_file :picture, styles: { medium: '300x300>', thumb: '100x100>' }, default_url: '/images/medium/missing.png'
  validates_attachment :picture,
                       presence: true,
                       content_type: { content_type: %w[image/jpeg image/png] },
                       size: { in: 0..1.megabytes }

  do_not_validate_attachment_file_type :picture

  has_many :documents

  def save_attachments(params)
    params[:document_data].each do |doc|
      documents.create(file_contents: doc)
    end
  end

  private

  def parse_image
    image = Paperclip.io_adapters.for(image_base)
    image.original_filename = 'file.jpg'
    self.picture = image
  end
end
