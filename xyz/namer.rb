require "securerandom"

module XYZ
  class Namer
    attr_reader :file

    def self.xyz_filename(file)
      new(file).filename
    end

    def initialize(file)
      @file = file
    end

    def filename
      [prefix, age, file.id, noise, title].compact.join("_").concat(".jpg")
    end

    private

    def prefix = [publication_day, category, kind].join
    def publication_day = file.publish_on.strftime("%d")
    def category = file.xyz_category_prefix
    def kind = file.kind.delete("_")
    def age = file.personal? ? format("%03d", file.age.to_i) : nil
    def noise = @noise ||= SecureRandom.hex(4)
    def title = sanitized_title[0, 10]
    def sanitized_title = file.title.downcase.gsub(/[^\[a-z\]]/, "")
  end
end
