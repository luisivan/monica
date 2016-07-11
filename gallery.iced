
q = 9

class Gallery
  constructor : () ->
    imgs = $('#gallery figure')
    @items = []

    await
      @addImg img, defer() for i, img of Captions

    $('#gallery').masonry
      itemSelector: 'figure'
      columnWidth: '.grid-item'
      gutter: 10

  addImg : ({title, text}, cb) ->
    url = encodeURIComponent title
    el = $("<figure class='grid-item' itemprop='associatedMedia' itemscope itemtype='http://schema.org/ImageObject'>
                <a href='imgs/gallery/#{url}.jpg' itemprop='contentUrl'>
                    <img src='imgs/gallery/#{url}-Preview.jpg' itemprop='thumbnail'/>
                </a>
                <figcaption itemprop='caption description'>#{title}</figcaption>
            </figure>")

    img = new Image()
    img.onload = () =>
      @items.push
        src: el.find('a').attr 'href'
        w: img.width
        h: img.height
        title: text
        msrc: el.find('img').attr 'src'

      el.on 'click', (e) =>
        e.preventDefault()
        @show $(el)

      el.data 'pswp-uid', @items.length - 1
      el.hide()
      $('#gallery').append el
      el.fadeIn()
      cb()

    img.src = "imgs/gallery/#{url}.jpg"

  show : (el) ->
    index = parseInt $(el).data 'pswp-uid'
    opts =
      index: index
      getThumbBoundsFn: (i) =>
        # See Options -> getThumbBoundsFn section of documentation for more info
        thumbnail = el.find('img')[0]
        pageYScroll = window.pageYOffset or document.documentElement.scrollTop
        rect = thumbnail.getBoundingClientRect()
        {
          x: rect.left
          y: rect.top + pageYScroll
          w: rect.width
        }

    gallery = new PhotoSwipe $('.pswp')[0], PhotoSwipeUI_Default, @items, opts
    gallery.init()
    $('.pswp__button--buy').empty().append "<a id='buy' class='gumroad-button' href='#{Captions[index].buy}'>Buy</a>"
    #$.getScript 'https://gumroad.com/js/gumroad.js'

new Gallery()

email = 'rou' + '@' + 'monicazeng.com'
  $('#email').attr 'href', "mailto:#{email}"
