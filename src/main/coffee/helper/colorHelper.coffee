define ['cs!coffee/helper/hashFunctions'], (hashFunctions) ->
  class ColorHelper
    getColorFor: (id) ->
      "#" + pad((Math.abs(hashFunctions.djb2("#{id}")) % 16777216).toString(16), '0', 6)

    pad = (value, fillCharacter, length) ->
      text = '' + value;
      while (text.length < length)
        text = fillCharacter + text
      return text;

  return new ColorHelper()