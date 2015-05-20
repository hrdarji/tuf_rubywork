#Trying to initialize root from given code

class Release
  attr_reader :targets
#need root and release.txt file to initialize

  def initialize root, release_txt
    parsed = JSON.parse release_txt
    @release = root.verify(:release, parsed)
    @targets = @release["meta"]["targets.txt"]
  end
end