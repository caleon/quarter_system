REGES = { :with_method_name                   => '(?:_with_([a-z0-9]+(?:[a-z0-9]|_(?![_=\b]))*?))?',
               :method_name                   =>          '([a-z0-9]+(?:[a-z0-9]|_(?![_=\b]))*?)',
               :method_name_with_setter       =>          '([a-z0-9]+(?:[a-z0-9]|_(?![_=\b]))*?)(=?)',
               :method_name_without_capture   =>        '(?:[a-z0-9]+(?:[a-z0-9]|_(?![_=\b]))*?)' }
               
# REGEX is the Regular Expression that is not anchored.
REGEX = Hash[*REGES.to_a.map do |arr|
[ arr[0], 
  if arr[1].is_a?(Hash)
    Hash[*arr[1].to_a.map { |key, reges| [ key, Regexp.new(reges, Regexp::IGNORECASE) ] }.flatten]
  else
    Regexp.new(arr[1], Regexp::IGNORECASE)
  end ]
end.flatten]