require "securerandom"

module XYZ
  class Namer < Struct.new(:file)
    def self.xyz_filename(file)
      new(file).filename
    end

    def filename
      "#{basename}.jpg"
    end

    private

    def basename
      [prefix, age, file.id, noise, title].compact.join("_")
    end

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
      file.kind.gsub("_", "")
    end

    def age
      format("%03d", file.age || 0) if file.personal?
    end

    def noise
      SecureRandom.hex(4)
    end

    def title
      file.title.downcase.gsub(/[^\[a-z\]]/, "")[0, 10]
    end
  end
end
