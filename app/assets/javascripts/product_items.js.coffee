# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  max_fields = 10 #maximum input boxes allowed
  add_button = $(".add_code") #Add button ID

  x = 1 #initlal text box count
  $(add_button).click (e) -> #on add input button click
    e.preventDefault()
    wrapper = $(this).parent() #Fields wrapper
    if x < max_fields #max input box allowed
      x++ #text box increment
      $(wrapper).append "<div><input type=\"text\" name=\"codes[]\" class=\"code_field\"/></div>" #add input box
    return


  $(".code_field").bind "keydown", (event) ->
    if event.which is 13 #TODO: doesnt work
      event.stopPropagation()
      event.preventDefault()
      $(this).nextAll(".code_field").eq(0).focus()


  $("#code_submit").click (event) ->
    event.preventDefault()
    alert('submitting')
    codes = []
    $('.code_field').each ->
      codes.push($(this).val())
    url = "/product_items/"+$("#select_check").val()
    $.ajax({
      type: "POST",
      dataType: 'json',
      url: url,
      data: { 'codes':codes },
      success:(data) ->
        alert data
        return false
      error:(data) ->
        return false
    })

