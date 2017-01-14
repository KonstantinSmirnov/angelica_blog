jQuery ($) ->
  $(document).on "turbolinks:load ajaxComplete", ->
    $(".delete_section").on "click", ->
      $(this).prev('input[type=hidden]').val('1')
      $(this).closest('.article_section').hide()
      event.preventDefault()
