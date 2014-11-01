require ['jquery'], ($) ->

  startCalibration = (itemToCalibrate) ->
    writeValuesBack = (values) ->
      $('#input-multX').val values.multX
      $('#input-addX').val values.addX
      $('#input-multY').val values.multY
      $('#input-addY').val values.addY
      $('#input-multZ').val values.multZ
      $('#input-addZ').val values.addZ
      $('#input-lineThickness').val values.lineThickness

      $('#value-multX').text values.multX
      $('#value-addX').text values.addX
      $('#value-multY').text values.multY
      $('#value-addY').text values.addY
      $('#value-multZ').text values.multZ
      $('#value-addZ').text values.addZ
      $('#value-lineThickness').text values.lineThickness

    takeOverValues = ->
      multX = parseInt $('#input-multX').val()
      addX = parseInt $('#input-addX').val()
      multY = parseInt $('#input-multY').val()
      addY = parseInt $('#input-addY').val()
      multZ = parseInt $('#input-multZ').val()
      addZ = parseInt $('#input-addZ').val()
      lineThickness = parseInt $('#input-lineThickness').val()

      values = {"multX": multX, "addX": addX, "multY": multY, "addY": addY, "multZ": multZ, "addZ": addZ, "lineThickness": lineThickness}

      itemToCalibrate.calibration(values)
      writeValuesBack(values)

    $('#calibration-area').css('display', 'block')
    $('.range-input-field').change ->
      takeOverValues();
    writeValuesBack(itemToCalibrate.calibration())

  interval = setInterval(->
    if window.itemToCalibrate?
      console.log("Init calibration")
      clearInterval interval
      startCalibration(window.itemToCalibrate)
  , 500)