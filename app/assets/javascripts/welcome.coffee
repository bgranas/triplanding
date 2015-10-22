# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->

  alert 'test';

  $('a[href^="#"]').on 'click.smoothscroll', (e) ->
    e.preventDefault()

    target = @hash
    $target = $(target)

    $('html, body').stop().animate {
      'scrollTop': $target.offset().top
    }, 500, 'swing', ->
      window.location.hash = target

  #Countdown JS
   `$(function(){
        $(".digits").countdown({
          image: "assets/digits.png",
          format: "dd:hh:mm:ss",
          endTime: new Date(2016, 0, 1)
        });
    });`
