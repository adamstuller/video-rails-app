const infiniteScrolling = () => {
    const THRESHOLD = 100;
    const $paginElem = $('#infinite-scrolling')
    const $products = $('#products')



    if( $paginElem.length ){

        $paginElem.hide()

        $(window).scroll( () => {
            let more_posts_url = $(' a.next_page').attr('href')
            if ( more_posts_url && $(window).scrollTop() > $(document).height() - $(window).height() - THRESHOLD){
                $('#infinite-scrolling').text('Fetching')
                jQuery.get(more_posts_url, (data) => {
                    const html = jQuery.parseHTML(data)
                    let nextPagination
                    $.each(html , (i, el) => {
                        if(el.nodeName === 'MAIN'){
                            const newProds = el.children[0].children[0].children[0]

                            $products.append(newProds)
                            nextPagination = el.children[0].children[1].children[0]
                            console.log('replacing ' + nextPagination.children[2])
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