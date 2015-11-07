#anything code related to trips/new and trips/edit should be put here.

$ ->

  $(document).bind 'cbox_complete', ->
    initSearch() #calling initSearch because initial call didn't bind to lightbox input
