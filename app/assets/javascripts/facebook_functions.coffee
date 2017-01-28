jQuery ($) ->
  $(document).on "turbolinks:load", ->
    @share_facebook = (link, title, image, caption, description) ->
      FB.ui
        method      : 'feed'
        link        : link
        name        : title
        picture     : image
        caption     : caption
        description : description
