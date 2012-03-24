jQuery ->
  $LAB.setOptions(AlwaysPreserveOrder: true)
  $LAB.script("js/Aurora.js").script('js/ArrayText.js')
      .script('js/Capacity.js').script('js/extensions/Capacity.js').wait ->
    alert("aurora.js loaded")
    console.log(window.aurora.Capacity)
    try
      window.cap = new window.aurora.Capacity
    catch err
      console.log(err)

    alert("window.cap created")
    $("#log_cap_xml").click ->
      console.log window.cap.to_xml(document.implementation.createDocument('document:xml'))