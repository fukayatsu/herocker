require 'digest/md5'

class ImagesController < ApplicationController
  def index
  end

  def show
    image = Image.find_by(name: params[:id])
    response.headers["Expires"] = 1.year.from_now.httpdate
    send_data(image.content, disposition: :inline, type: image.content_type)
  end

  def create
    file = params[:file]
    unless file
      return respond_to do |format|
        format.html { redirect_to images_path  }
        format.json { render json: { error: 'file is missing'} }
      end
    end

    if ENV['HEROKER_UPLOAD_TOKEN'] && ENV['HEROKER_UPLOAD_TOKEN'] != params[:upload_token]
      return respond_to do |format|
        format.html { redirect_to images_path  }
        format.json { render json: { error: 'invalid upload_token'} }
      end
    end


    image_blob = file.read
    name = Digest::MD5.hexdigest(image_blob)

    if image = Image.find_by(name: name)
      image.update!(updated_at: Time.now)
    else
      image = Image.create!(
        name:              name,
        original_filename: file.original_filename,
        extname:           File.extname(file.original_filename),
        content:           image_blob,
        content_type:      file.content_type,
        size:              image_blob.size,
        protected:         false,
      )

      Image.order(updated_at: :asc).first.delete if Image.count > 9000
    end

    respond_to do |format|
      format.html {
        redirect_to image_path(image.name + image.extname)
      }
      format.json {
        render json: {
          image_url: image_url(image.name + image.extname)
        }
      }
    end
  end
end
