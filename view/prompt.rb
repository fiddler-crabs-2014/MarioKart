# singleton class to manage user input
class PromptManager
  def initialize(args = {})
    @language = args[:lang]
    @config = args[:configuration]
  end

  def self.prompt
    gets.chomp
  end

  def self.validated_prompt(regex)
    input = self.prompt
    yield if input !~ regex
    input
  end
end
