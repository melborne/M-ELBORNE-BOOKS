class Kitabu < Thor
  REPO = "~/Library/Containers/ee.64.Kitabu/Data/Documents/ePubLibrary"

  desc "open epub file", "delete file in the target repo and open epub file with Kitabu"
  def open(filename="out.epub")
    path = File.expand_path(File.join(REPO, filename))
    if File.exist?(path)
      File.delete(path).tap do |i|
        puts "#{filename} deleted in the target repo." if i > 0
      end
    end
    system("open", filename)
  end
end
