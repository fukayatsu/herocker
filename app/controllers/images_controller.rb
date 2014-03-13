require 'digest/md5'

class ImagesController < ApplicationController
  before_action :set_image,              only: [:show]
  before_action :set_expires_header,     only: [:show]
  before_action :authorize_with_token,   only: [:create]
  before_action :create_or_update_image, only: [:create]

  def index
  end

  def show
    send_data(@image.content, disposition: :inline, type: @image.content_type)
  end

  def create
    respond_to do |format|
      format.html { redirect_to @image }
      format.json
    end
  end

private

  def authorize_with_token
    return if ENV['HEROKER_UPLOAD_TOKEN'].blank?
    return if ENV['HEROKER_UPLOAD_TOKEN'] == params[:upload_token]

    respond_to do |format|
      format.html { redirect_to images_path  }
      format.json { render json: { error: 'invalid upload_token'} }
    end
  end

  def set_expires_header
    response.headers["Expires"] = 1.year.from_now.httpdate
  end

  def set_image
    return if @image = Image.find_by(name: params[:id])

    @error_message = "image not found"
    respond_to do |format|
      format.html { redirect_to images_path  }
      format.json { render :error }
    end
  end

  def create_or_update_image
    return if @image = Image.update_or_create_from_file!(params[:file])  ||
      Image.update_or_create_from_blob!(params[:image])

    @error_message = "image is missing"
    respond_to do |format|
      format.html { redirect_to images_path  }
      format.json { render :error }
    end
  end
end
