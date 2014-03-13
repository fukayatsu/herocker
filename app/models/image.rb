class Image < ActiveRecord::Base
  after_create :delete_exceeded_image

  def to_param
    self.name + self.extname
  end

  class << self
    def update_or_create!(file, base64image)
      return nil if file.blank? && base64image.blank?

      image_blob = file.try(:read) || Base64.decode64(base64image)
      name = Digest::MD5.hexdigest(image_blob)

      if image = find_by(name: name)
        image.update!(updated_at: Time.now)
        return image
      end

      image = new(
        name:              name,
        content:           image_blob,
        size:              image_blob.size,
        protected:         false
      )

      if file.present?
        image.attributes = {
          original_filename: file.original_filename,
          extname:           File.extname(file.original_filename),
          content_type:      file.content_type,
        }
      else
        ext          = detect_file_type(image_blob)
        content_type = ext == "jpg" ? "image/jpeg" : "image/#{ext}"
        image.attributes = {
          original_filename: "_image.#{ext}",
          extname:           ".#{ext}",
          content_type:      content_type,
        }
      end
      image.save!
      image
    end

  private

    def detect_file_type(blob)
      png  = Regexp.new("\x89PNG".force_encoding("binary"))
      jpg  = Regexp.new("\xff\xd8\xff\xe0\x00\x10JFIF".force_encoding("binary"))
      jpg2 = Regexp.new("\xff\xd8\xff\xe1(.*){2}Exif".force_encoding("binary"))
      case blob
      when /^GIF8/
        'gif'
      when /^#{png}/
        'png'
      when /^#{jpg}/
        'jpg'
      when /^#{jpg2}/
        'jpg'
      else
        'unknown'
      end
    end
  end

private
  def delete_exceeded_image
    Image.order(updated_at: :asc).first.delete if Image.count > 9000
  end
end
