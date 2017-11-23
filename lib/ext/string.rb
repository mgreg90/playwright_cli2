class String

  SPECIAL_CHARS_REGEX = /[\~\`\!\@\#\$\%\^\&\*\(\)\-\=\+\\\|\\}\[\{\'\"\;\:\/\?\.\>\,\<\_]/.freeze
  CAPITAL_LETTERS_REGEX = /[A-Z]/

  def to_camel_case(pascal=false)
    gsub(SPECIAL_CHARS_REGEX) { ' ' }
    .split
    .map.with_index do |match, index|
      !pascal && index == 0 ? match : match.capitalize
    end.join
  end

  def to_snake_case
    gsub(CAPITAL_LETTERS_REGEX) { |match| "_#{match.downcase}" }
      .gsub(SPECIAL_CHARS_REGEX) { ' ' }.split.join('_').downcase
  end

  def to_pascal_case
    to_camel_case(true)
  end

  def to_dash_case
    to_snake_case.gsub('_', '-')
  end

  def to_const
    Object.const_get(self.to_pascal_case)
  end

end