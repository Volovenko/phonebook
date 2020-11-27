require 'csv'
require 'activerecord-import/base'
class PhonesController < ApplicationController

  before_action :set_phone, only: [:show, :edit, :update, :destroy]

  def index
    @phones = Phone.all
    respond_to do |format|
      format.html
      format.csv { send_data @phones.to_csv }
    end
  end

  def import
    Phone.my_import(params[:file])
    redirect_to root_path, notice: "successfully imported data"
  end

  def new
    @phone = Phone.new
  end

  def create
    @phone = Phone.new(phone_params)

    respond_to do |format|
      if @phone.save
        format.js
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @phone.update(phone_params)
        format.js
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @phone.destroy
    respond_to do |format|
      format.js
    end
  end

  private

    def set_phone
      @phone = Phone.find(params[:id])
    end

    def phone_params
      params.require(:phone).permit(:name, :number)
    end
end
