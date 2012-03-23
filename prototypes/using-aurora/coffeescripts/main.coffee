jQuery ->
  $("#log_cap_xml").click ->
    console.log window.cap.to_xml(document.implementation.createDocument('document:xml'))
  window.cap = new window.aurora.Capacity
    link_id: 4
    dt: 120.0
