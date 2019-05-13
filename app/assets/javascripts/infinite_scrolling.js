const infiniteScrolling = () => {
    const THRESHOLD = 100;
    if( $('#infinite-scrolling').length ){

        $('#infinite-scrolling').hide()
        $(window).scroll( () => {
            $('#infinite-scrolling').hide()
            let more_posts_url = $(' a.next_page').attr('href')
            if ( more_posts_url && $(window).scrollTop() > $(document).height() - $(window).height() - THRESHOLD){
                $('#infinite-scrolling').text('Fetching')
                jQuery.get(more_posts_url, (data) => {
                    const html = jQuery.parseHTML(data)
                    let nextPagination
                    $.each(html , (i, el) => {
                        if(el.nodeName === 'MAIN'){
                            const newProds = el.getElementsByClassName('scrollable')
                            $('#products').append( newProds)
                            nextPagination = el.getElementsByClassName('pagination')
                            $('#infinite-scrolling').replaceWith($(nextPagination))
                            $('#infinite-scrolling').hide()
                        }
                    })
                })
            }
        })
    }
}
jQuery(infiniteScrolling)