require "securerandom"

module XYZ
  class Namer < Struct.new(:file)
    def self.xyz_filename(file)
      new(file).filename
    end

    def filename
      [prefix, age, file_id, noise, title].compact.join("_").concat(".jpg")
    end

    def prefix
      [publication_date, category, kind].join
    end

    def publication_date
      file.publish_on.strftime("%d")
    end

    def category
      file.xyz_category_prefix
    end

    def kind
      file.kind.delete("_")
    end

    def age
      format("%03d", (file.age || 0)) if file.personal?
    end

    def file_id
      file.id
    end

    def noise
      SecureRandom.hex(4)
    end

    def title
      file.title.downcase.gsub(/[^\[a-z\]]/, "")[0, 10]
    end
  end
end
