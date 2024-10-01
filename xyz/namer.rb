require "digest"

module XYZ
  class Namer < Struct.new(:file)
    def self.xyz_filename(file)
      new(file).filename
    end

    def filename
      [prefix, age, file.id, noise, title].compact.join("_").concat(".jpg")
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
      file.kind.gsub("_", "")
    end

    def age
      format("%03d", (file.age || 0)) if file.personal?
    end

    def noise
      Digest::SHA1.hexdigest(rand(10_000).to_s)[0, 8]
    end

    def title
      truncated_title = file.title.gsub(/[^\[a-z\]]/i, "").downcase
      truncate_to = [truncated_title.length, 9].min
      (truncated_title[0..(truncate_to)])
    end
  end
end
