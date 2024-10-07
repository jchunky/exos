require "securerandom"

module XYZ
  class Namer < Struct.new(:file)
    def self.xyz_filename(file)
      new(file).filename
    end

    def filename
      parts = [prefix, age, file_id, noise, title].compact
      parts.join("_").concat(".jpg")
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
      file.kind.tr("_", "")
    end

    def age
      return unless file.personal?

      format("%03d", file.age || 0)
    end

    def file_id
      file.id
    end

    def noise
      generate_random_hex(8)
    end

    def generate_random_hex(length)
      SecureRandom.hex(length / 2)
    end

    def title
      sanitized_title[0, 10]
    end

    def sanitized_title
      file.title.downcase.gsub(/[^\[a-z\]]/, "")
    end
  end
end
