require 'csv'
require 'activerecord-import/base'


class Phone < ApplicationRecord

  validates :name, :number, presence: true, length: {maximum: 35}

  def self.to_csv(options = {})
    CSV.generate(options) do | csv |
      csv << ["Name", "Number"]
      all.each do | phone |
        csv << phone.attributes.values_at("name", "number")
      end
    end
  end

  def self.my_import(file)
    phones = []
    CSV.foreach(file.path, headers: true) do | row |
      phones << Phone.new(row.to_h)
    end
    Phone.import phones, on_duplicate_key_update: {conflict_target: [:id], columns: [:name, :number] }
  end
end
