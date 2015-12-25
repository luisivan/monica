q = 4

class Gallery
  constructor : () ->
    imgs = $('#gallery figure')
    @items = []

    await
      for i in [0...q]
        @addImg i, defer()

    $('#gallery').masonry
      itemSelector: 'figure'
      columnWidth: '.grid-item'
      gutter: 10

  addImg : (i, cb) ->
    el = $("<figure class='grid-item' itemprop='associatedMedia' itemscope itemtype='http://schema.org/ImageObject'>
                <a href='imgs/#{i}.jpg' itemprop='contentUrl'>
                    <img src='imgs/#{i}-preview.jpg' itemprop='thumbnail' alt='Image description' />
                </a>
                <figcaption itemprop='caption description'>Image caption</figcaption>
            </figure>")

    img = new Image()
    img.onload = () =>
      @items.push
        src: el.find('a').attr 'href'
        w: img.width
        h: img.height
        title: el.find('figcaption').text()
        msrc: el.find('img').attr 'src'

      el.on 'click', (e) =>
        e.preventDefault()
        @show $(el)

      el.data 'pswp-uid', @items.length - 1
      el.hide()
      $('#gallery').append el
      el.fadeIn()
      cb()

    img.src = "imgs/#{i}.jpg"

  show : (el) ->
    opts =
      index: parseInt $(el).data 'pswp-uid'
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

new Gallery()

email = 'me' + '@' + 'monicazeng.com'
$('#email span').text email
$('#email').attr 'href', "mailto:#{email}"
