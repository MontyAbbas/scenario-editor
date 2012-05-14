# class to generate indentation strings (yeesh!)
# Usage:
#   s = StringIndenter.indent(n)
#
# in ruby this would just be " " * n
#
# the indent strings are memoized, at least
#
class StringIndenter
  @ih = ["", " "]

  StringIndenter.indent = (n) ->
    if not @ih[n] then @ih[n] = @indent(n-1) + " "
    return @ih[n]

