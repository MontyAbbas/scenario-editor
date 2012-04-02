class window.aurora.ArrayText
  @slice_and_dice: (data, delims, convert) ->
    dim = delims.length

    switch dim
      when 0 then @convert(data)
      when 1
        if data.length == 0
          []
        else
          _.map(data.split(delims[0]),(s) -> convert(s))
      else
        rest_delims = delims.slice(1,1000000)
        _.map(data.split(delims[0]),
              (s) => @slice_and_dice(s, rest_delims, convert))

  @convert_cell_to_number: (s) ->
    n = Number(s)

    if isNaN(s)
      throw "Invalid numeric data in cell: #{s}"
    n

  @convert_cell_to_string: (s) ->
    s

  @fn_to_convert_cell_from: (cell_type, object_with_id) ->
    switch cell_type
      when "String" then @convert_cell_to_string
      when "Number" then @convert_cell_to_number
      else (id) -> object_with_id[id]

  @parse: (input, delims, cell_type, object_with_id) ->
    data = String(input)
    convert = @fn_to_convert_cell_from(cell_type, object_with_id)
    if(convert is null)
      throw "bad input, cell_type = #{cell_type}"
    @slice_and_dice(data, delims, convert)

  @emit: (input, delims = null, indenter = "") ->
    dim = if delims? then delims.length else 0
    ind = ""

    switch dim
      when 0 then input.toString()
      when 1 then input.join(delims[0])
      when 2
        ind = indenter + "  "
        ind + _.map(input, (a) => @emit(a, delims.slice(1,2), indenter)).join(delims[0] + ind)
      when 3
        ind = indenter + "  "
        ind + _.map(input, (a) -> _.map(a,(a1) -> a1.join(delims[2])).join(delims[1])).join(delims[0] + ind)
      else input.toString()