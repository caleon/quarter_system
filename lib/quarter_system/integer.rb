# There is already a Fixnum#ordinalize
class Integer
  ORDINALS = %w(first second third fourth fifth sixth seventh eighth ninth tenth eleventh twelfth)
  def ordinal(nonnumeric=false)
    if nonnumeric && (1..ORDINALS.size.succ).include?(self)
      ORDINALS[pred]
    elsif nonnumeric
      to_s + ([ [ nil, 'st','nd','rd' ], [] ][self / 10 == 1 && 1 || 0][self % 10] || 'th')
    end
  end
end