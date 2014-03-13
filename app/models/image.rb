require "filemagic"

class Image < ActiveRecord::Base
  after_create :delete_exceeded_image

  def to_param
    self.name + self.extname
  end

  class << self
    def update_or_create_from_file!(file)
      return nil if file.blank?

      image_blob = file.read
      name = Digest::MD5.hexdigest(image_blob)

      if image = find_by(name: name)
        image.update!(updated_at: Time.now)
        return image
      end

      create!(
        name:              name,
        original_filename: file.original_filename,
        extname:           File.extname(file.original_filename),
        content:           image_blob,
        content_type:      file.content_type,
        size:              image_blob.size,
        protected:         false,
      )
    end

    def update_or_create_from_blob!(base64image)
      return nil if base64image.blank?

      # image_blob = base64image.unpack('m')[0]
      image_blob = Base64.decode64(base64image)
      name = Digest::MD5.hexdigest(image_blob)
      if image = find_by(name: name)
        image.update!(updated_at: Time.now)
        return image
      end

      content_type = detect_content_type(image_blob)
      ext          = content_type.split('/')[1]

      create!(
        name:              name,
        original_filename: "_image.#{ext}",
        extname:           ".#{ext}",
        content:           image_blob,
        content_type:      content_type,
        size:              image_blob.size,
        protected:         false,
      )
    end

    def detect_content_type(blob)
      fm = FileMagic.mime
      fm.simplified = true
      content_type  = nil
      Tempfile.open('blob_tmp_') do |tempfile|
        tempfile.binmode
        tempfile.write(blob)
        content_type = fm.file(tempfile.path)
      end
      content_type
    end
  end

private
  def delete_exceeded_image
    Image.order(updated_at: :asc).first.delete if Image.count > 9000
  end
end
