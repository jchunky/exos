require "securerandom"

module XYZ
  class Namer < Struct.new(:file)
    def self.xyz_filename(file)
      new(file).filename
    end

    def filename
      parts = [prefix, age, file.id, noise, title]
      parts.compact.join("_").concat(".jpg")
    end

    private

    def prefix
      [publication_day, category, kind].join
    end

    def publication_day
      file.publish_on.strftime("%d")
    end

    def category
      file.xyz_category_prefix
    end

    def kind
      file.kind.delete("_")
    end

    def age
      format("%03d", file.age.to_i) if file.personal?
    end

    def noise
      SecureRandom.hex(4)
    end

    def title
      sanitized_title[0, 10]
    end

    def sanitized_title
      file.title.downcase.gsub(/[^\[a-z\]]/, "")
    end
  end
end
