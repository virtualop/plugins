param "length", default: 12
param "options", default: { avoid_symbols: true }

run do |length, options|
  # TODO [vop] auto-conversion for ints would be cool
  generated = PasswordGenerator.generate(length.to_i, options)
  # strip different kinds of quotes in order not to fuck up whoever needs to use it
  generated.tr('`"\'', '')
end
