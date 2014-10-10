(function(window, undefined) {

    /*********************** START STATIC ACCESS METHODS ************************/

    jQuery.extend(jimMobile, {
        "loadScrollBars": function() {
            jQuery(".s-d12245cc-1680-458d-89dd-4f0d7fb22724 .ui-page").overscroll({ showThumbs:true, direction:'vertical' });
            jQuery(".s-d12245cc-1680-458d-89dd-4f0d7fb22724 #s-Panel_4").overscroll({ showThumbs:false, direction:'vertical' });
            jQuery(".s-0fa6dd09-4e28-432e-99c8-c3f6dab98aed .ui-page").overscroll({ showThumbs:true, direction:'vertical' });
            jQuery(".s-0fa6dd09-4e28-432e-99c8-c3f6dab98aed #s-Panel_3").overscroll({ showThumbs:false, direction:'vertical' });
            jQuery(".s-98b6b60a-fd24-41be-927e-5ddf87cf136a .ui-page").overscroll({ showThumbs:true, direction:'vertical' });
         }
    });

    /*********************** END STATIC ACCESS METHODS ************************/

}) (window);