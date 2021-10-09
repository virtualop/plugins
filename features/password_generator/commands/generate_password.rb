param "length", default: 12
param "symbols", default: true

run do |length, symbols|
  # TODO [vop] auto-conversion for ints would be cool
  generated = Passgen::generate(:length => length.to_i, symbols: symbols)

  # strip different kinds of quotes in order not to fuck up whoever needs to use it
  generated.tr('`"\'', '')
end
